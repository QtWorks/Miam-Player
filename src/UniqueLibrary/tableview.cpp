#include "tableview.h"

#include <model/sqldatabase.h>
#include <libraryfilterproxymodel.h>
#include <libraryscrollbar.h>
#include <settingsprivate.h>

#include <QGuiApplication>
#include <QHeaderView>
#include <QPainter>
#include <QRegularExpression>
#include <QScrollBar>
#include <QSqlQuery>
#include <QSqlRecord>

#include <QtDebug>

TableView::TableView(QWidget *parent)
	: QTableView(parent)
	, _model(new UniqueLibraryItemModel(this))
	, _jumpToWidget(new JumpToWidget(this))
	, _skipCount(1)
{
	_model->proxy()->setDynamicSortFilter(false);
	this->setModel(_model->proxy());
	this->setVerticalScrollMode(ScrollPerPixel);
	LibraryScrollBar *vScrollBar = new LibraryScrollBar(this);
	this->setVerticalScrollBar(vScrollBar);
	connect(_jumpToWidget, &JumpToWidget::aboutToScrollTo, this, &TableView::jumpTo);
	connect(_model->proxy(), &UniqueLibraryFilterProxyModel::aboutToHighlightLetters, _jumpToWidget, &JumpToWidget::highlightLetters);
	connect(vScrollBar, &QAbstractSlider::valueChanged, this, [=](int) {
		QModelIndex iTop = indexAt(viewport()->rect().topLeft());
		_jumpToWidget->setCurrentLetter(_model->currentLetter(iTop.sibling(iTop.row(), 1)));
	});
	this->installEventFilter(this);
	horizontalHeader()->resizeSection(0, Settings::instance()->coverSizeUniqueLibrary());

	connect(selectionModel(), &QItemSelectionModel::selectionChanged, [=](const QItemSelection &, const QItemSelection &) {
		if (viewport()) {
			setDirtyRegion(QRegion(viewport()->rect()));
		}
	});

	SettingsPrivate *settingsPrivate = SettingsPrivate::instance();
	QFont f = settingsPrivate->font(SettingsPrivate::FF_Library);

	auto loadFont = [this] (const QFont &f) -> void {
		this->setFont(f);
		QFontMetrics fm = this->fontMetrics();
		verticalHeader()->setDefaultSectionSize(fm.height());
	};
	loadFont(f);

	connect(settingsPrivate, &SettingsPrivate::fontHasChanged, this, [=](SettingsPrivate::FontFamily ff, const QFont &newFont) {
		if (ff == SettingsPrivate::FF_Library) {
			loadFont(newFont);
		}
	});

}

TableView::~TableView()
{
	if (selectionModel()) {
		selectionModel()->disconnect();
	}
}

/** Redefined to disable search in the table and trigger jumpToWidget's action. */
void TableView::keyboardSearch(const QString &search)
{
	// If one has assigned a simple key like 'N' to 'Skip Forward' we don't actually want to skip the track
	// IMHO, it's better to trigger the JumpTo widget to 'N' section
	static QRegularExpression az("[a-z]", QRegularExpression::CaseInsensitiveOption | QRegularExpression::OptimizeOnFirstUsageOption);
	if (az.match(search).hasMatch()) {
		if (jumpToWidget()->currentLetter() == search.toUpper().at(0)) {
			_skipCount++;
		} else {
			_skipCount = 1;
		}
		this->jumpTo(search);
	}
}

/** Redefined to override shortcuts that are mapped on simple keys. */
bool TableView::eventFilter(QObject *obj, QEvent *event)
{
	if (event->type() == QEvent::ShortcutOverride) {
		QKeyEvent *keyEvent = static_cast<QKeyEvent*>(event);
		if (keyEvent->modifiers().testFlag(Qt::NoModifier)) {
			// If one has assigned a simple key like 'N' to 'Skip Forward' we don't actually want to skip the track
			if (65 <= keyEvent->key() && keyEvent->key() <= 90) {
				// We don't want this event to be propagated
				keyEvent->accept();
				return true;
			}
		} else {
			keyEvent->ignore();
			return false;
		}
	}
	return QTableView::eventFilter(obj, event);
}

/** Redefined to keep displayed covers untouched. */
void TableView::mouseMoveEvent(QMouseEvent *event)
{
	// Don't allow click on first column which contains the cover (it can erase parts of painted image)
	if (columnAt(event->pos().x()) != 0) {
		QTableView::mouseMoveEvent(event);
	}
}

/** Redefined to keep displayed covers untouched. */
void TableView::mousePressEvent(QMouseEvent *event)
{
	// Don't allow click on first column which contains the cover (it can erase parts of painted image)
	if (columnAt(event->pos().x()) != 0) {
		QTableView::mousePressEvent(event);
	}
}

void TableView::paintEvent(QPaintEvent *event)
{
	int wVerticalScrollBar = 0;
	if (verticalScrollBar()->isVisible()) {
		wVerticalScrollBar = verticalScrollBar()->width();
	}
	if (QGuiApplication::isLeftToRight()) {
		///XXX: magic number
		_jumpToWidget->move(frameGeometry().right() - 22 - wVerticalScrollBar, 0);
	} else {
		_jumpToWidget->move(frameGeometry().left() + wVerticalScrollBar, 0);
	}

	if (_model->rowCount() == 0) {
		QPainter p(this->viewport());
		p.drawText(this->viewport()->rect(), Qt::AlignCenter, tr("No matching results were found"));
	} else {
		QTableView::paintEvent(event);
	}
}

void TableView::jumpTo(const QString &letter)
{
	SqlDatabase db;
	QSqlQuery firstArtist(db);
	firstArtist.prepare("SELECT artist FROM cache WHERE artist LIKE ? ORDER BY artist COLLATE NOCASE LIMIT ?");
	firstArtist.addBindValue(letter + "%");
	firstArtist.addBindValue(_skipCount);
	if (firstArtist.exec() && firstArtist.last()) {
		if (_skipCount != firstArtist.at() + 1) {
			firstArtist.first();
			_skipCount = 1;
		}
		for (QStandardItem *i : _model->findItems(firstArtist.record().value(0).toString(), Qt::MatchExactly, 1)) {
			if (i->type() == Miam::IT_Artist) {
				this->scrollTo(_model->proxy()->mapFromSource(i->index()), PositionAtTop);
				break;
			}
		}
	}
}

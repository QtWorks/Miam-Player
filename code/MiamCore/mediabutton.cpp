#include "mediabutton.h"

#include <settings.h>
#include <QFile>

#include <QtDebug>

MediaButton::MediaButton(QWidget *parent) :
	QPushButton(parent)
{
	this->setFlat(Settings::getInstance()->buttonsFlat());
}

/** Redefined to load custom icons saved in settings. */
void MediaButton::setIcon(const QIcon &icon)
{
	Settings *settings = Settings::getInstance();
	if (settings->isThemeCustomized() && settings->hasCustomIcon(objectName())) {
		QPushButton::setIcon(QIcon(settings->customIcon(objectName())));
	} else if (icon.isNull()){
		setIconFromTheme(settings->theme());
	} else {
		QPushButton::setIcon(icon);
	}
}

/** Load an icon from a chosen theme in options. */
void MediaButton::setIconFromTheme(const QString &theme)
{
	// The objectName in the UI file MUST match the alias in the QRC file!
	QString iconFile = ":/player/" + theme.toLower() + "/" + this->objectName().remove("Button");
	QIcon icon(iconFile);
	if (!icon.isNull()) {
		QPushButton::setIcon(QIcon(iconFile));
	}
	emit mediaButtonChanged();
}

/** Change the size of icons from the options. */
void MediaButton::setSize(const int &s)
{
	this->setIconSize(QSize(s, s));
	emit mediaButtonChanged();
}

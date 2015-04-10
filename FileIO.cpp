#include "FileIO.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDebug>

FileIO::FileIO(QObject *parent) : QObject(parent)
{
    settings = new QSettings;
    //settings->setValue("lastUser", "2");
}

void FileIO::createReport(QString fileName)
{
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly)) {

        return;
    }
}

void FileIO::appendToReport(QString fileName, QString row)
{
    QFile file(fileName);
    if (file.open(QIODevice::Append)) {
        QTextStream out(&file);
        out << row;
        file.close();
    }
}

void FileIO::closeReport(QString fileName)
{
    QFile file(fileName);

    if (file.open(QIODevice::WriteOnly)) {
        file.close();
    }
}

QString FileIO::documentsLocation()
{
    QString docPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    if(!docPath.endsWith("/"))
        docPath += "/";

    return docPath;
}

QString FileIO::convertDateTime(QString date)
{
    QDateTime datetime = QDateTime::fromString(date, "d.M.yyyy");
    qDebug() << " date: " << date;
    qDebug() << " date toString: " << datetime.toString("dddd d.M");
    return datetime.toString("dddd d.M");
}

QString FileIO::lastUser()
{
    QString lu = settings->value("lastUser").toString();
    return lu;
}

void FileIO::saveSettings(QString user)
{
    settings->setValue("lastUser", user);
}


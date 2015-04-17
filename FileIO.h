#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QDateTime>
#include <QSettings>

class FileIO : public QObject
{
    Q_OBJECT

public:
    QSettings* settings;

    explicit FileIO(QObject *parent = 0);
    Q_INVOKABLE void createReport(QString file);
    Q_INVOKABLE void appendToReport(QString file, QString row);
    Q_INVOKABLE void closeReport(QString file);
    Q_INVOKABLE QString documentsLocation();
    Q_INVOKABLE QString convertDateTime(QString date);
    Q_INVOKABLE QString lastUser();
    Q_INVOKABLE void saveSettings(QString user);
    Q_INVOKABLE void splitAndWriteLine(QString file, QString text);
};

#endif // FILEIO_H

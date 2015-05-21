#ifndef REPORTWRITER_H
#define REPORTWRITER_H

#include <QObject>
#include <QTextDocument>
#include <QDateTime>
#include <QTextCursor>
#include <QSettings>

class ReportWriter : public QObject
{
        Q_OBJECT

public:
    explicit ReportWriter(QObject *parent = 0);
    ~ReportWriter();

    QSettings* settings;

    Q_INVOKABLE void init();
    Q_INVOKABLE void addEntry(const QString &place, const QString &time, const double &bs, const QString &description, const QString &other);
    Q_INVOKABLE void addHeader(const QString &user, const QString &date);
    Q_INVOKABLE void write(const QString &fileName, const QString &type);
    Q_INVOKABLE QString documentsLocation();
    Q_INVOKABLE QString convertDateTime(QString date);
    Q_INVOKABLE QString lastUser();
    Q_INVOKABLE void saveSettings(QString user);
   //void addGraph(QList<int> values,const QString &subtext); Maybe some day :D

private:
    QTextCursor m_cursor;
    QTextDocument *m_document;
};

#endif // REPORTWRITER_H

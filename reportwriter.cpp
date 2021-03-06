#include "reportwriter.h"
#include <QObject>
#include <QTextDocument>
#include <QDateTime>
#include <QTextTableFormat>
#include <QTextDocumentWriter>
#include <QTextTable>
#include <QTextCursor>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDebug>

ReportWriter::ReportWriter(QObject *parent) : QObject(parent)
{
    m_document = new QTextDocument();
    m_cursor = QTextCursor(m_document);
    m_settings = new QSettings();
    qDebug() << " constructor called ********************************************************";
}

ReportWriter::~ReportWriter()
{
    delete m_document;
}

void ReportWriter::init()
{
    m_document = new QTextDocument();
    m_cursor = QTextCursor(m_document);
    qDebug() << " Init called ";
}

void ReportWriter::addEntry(const QString &place, const QString &time, const double &bs, const QString &description, const QString &other)
{
    QTextTable *table = m_cursor.currentTable();
    table->appendRows(1);
    m_cursor.movePosition(QTextCursor::PreviousRow);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(place);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(time);
    m_cursor.movePosition(QTextCursor::NextCell);

    if(bs == 0 || bs == 0.0)
        m_cursor.insertText("");
    else
        m_cursor.insertText(QString::number(bs));

    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(description);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(other);

    qDebug() << " Add entry: " << place << time << bs << description << other;
}

void ReportWriter::addHeader(const QString &user, const QString &date)
{
    //Format frame
    QTextFrameFormat frameFormat;
    frameFormat.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysBefore);
    m_cursor.movePosition(QTextCursor::End);
    m_cursor.insertFrame(frameFormat);

    QDate d = QDate::fromString(date, "yyyy.MM.dd");
    QVector <QTextLength> colWidths;

    colWidths << QTextLength (QTextLength::PercentageLength, 13.0);
    colWidths << QTextLength (QTextLength::PercentageLength, 8.2);
    colWidths << QTextLength (QTextLength::PercentageLength, 8.8);
    colWidths << QTextLength (QTextLength::PercentageLength, 40.0);
    colWidths << QTextLength (QTextLength::PercentageLength, 30.0);

    //Format text
    QTextCharFormat headerFormat = m_cursor.charFormat();
    headerFormat.setFontWeight(QFont::Bold);

    //Header text
    m_cursor.insertText(QObject::tr("VCS        %1\n\n").arg(user), headerFormat);
    m_cursor.insertText(QObject::tr("Päivämäärä: %1       Viikonpäivä: %2\n").arg(date, QDate::longDayName(d.dayOfWeek())), headerFormat);

    //Format table
    QTextTableFormat tableFormat;
    //tableFormat.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysAfter);
    tableFormat.setCellPadding(10);
    tableFormat.setHeaderRowCount(1);
    tableFormat.setBorderStyle(QTextFrameFormat::BorderStyle_Solid);
    //tableFormat.setWidth(QTextLength(QTextLength::PercentageLength, 100));
    //tableFormat.borderStyle(QTextFrameFormat::BorderStyle_Solid);
    //tableFormat.setCellSpacing(5);
    tableFormat.setBorderBrush(QBrush(Qt::SolidPattern));
    tableFormat.setBorder(1);
    tableFormat.setColumnWidthConstraints(colWidths);

    //Insert table header text
    m_cursor.insertTable(1, 5, tableFormat);
    m_cursor.insertText(QObject::tr("Paikka"), headerFormat);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(QObject::tr("Aika"), headerFormat);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(QObject::tr("VS"), headerFormat);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(QObject::tr("Ruoka ja määrä"), headerFormat);
    m_cursor.movePosition(QTextCursor::NextCell);
    m_cursor.insertText(QObject::tr("Liikkuminen, erityistilanteet"), headerFormat);

    qDebug() << " Add header: " << user + " " + date + " " + QDate::longDayName(d.dayOfWeek());
}

void ReportWriter::write(const QString &fileName, const QString &type)
{
   // QFileInfo file = new QFileInfo(fileName);
    QTextDocumentWriter writer(fileName);

   // if(file.completeSuffix() == "odt")
   // {
        writer.setFormat("odf");

        if(writer.write(m_document))
            qDebug() << " File successfully written to: " << fileName;
        else
            qDebug() << " Couldn't write file: " << fileName;
    //}
}

QString ReportWriter::documentsLocation()
{
    QString docPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    if(!docPath.endsWith("/"))
        docPath += "/";

    return docPath;
}

QString ReportWriter::convertDateTime(QString date)
{
    QDateTime datetime = QDateTime::fromString(date, "yyyy.MM.dd");
    qDebug() << " date: " << date;
    qDebug() << " date toString: " << datetime.toString("dddd d.M");
    return datetime.toString("dddd d.M");
}

QString ReportWriter::lastUser()
{
    QString lu = m_settings->value("lastUser").toString();
    return lu;
}

void ReportWriter::saveSettings(QString user)
{
    m_settings->setValue("lastUser", user);
}

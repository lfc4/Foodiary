#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QDateTime>
#include <QObject>
#include <reportwriter.h>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
   QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
   QScopedPointer<QQuickView> view(SailfishApp::createView());

   ReportWriter reportWriter;
   view->rootContext()->setContextProperty("ReportWriter", &reportWriter);
   view->setSource(SailfishApp::pathTo("qml/Foodiary.qml"));

   view->show();

    return app->exec();
}


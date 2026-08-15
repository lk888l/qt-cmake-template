#include "MainWindow.hpp"

#include <app/core/ApplicationInfo.hpp>

#include <QApplication>
#include <QCommandLineParser>
#include <QFile>
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(applicationLog, "qtapp.application")

int main(int argc, char *argv[])
{
    QApplication application(argc, argv);

    QApplication::setApplicationName(app::core::ApplicationInfo::name());
    QApplication::setApplicationDisplayName(app::core::ApplicationInfo::name());
    QApplication::setApplicationVersion(app::core::ApplicationInfo::version());
    QApplication::setOrganizationName(app::core::ApplicationInfo::organizationName());
    QApplication::setOrganizationDomain(app::core::ApplicationInfo::organizationDomain());

    QCommandLineParser parser;
    parser.setApplicationDescription(app::core::ApplicationInfo::description());
    parser.addHelpOption();
    parser.addVersionOption();
    parser.process(application);

    QFile styleSheetFile(QStringLiteral(":/qtapp/default.qss"));
    if (styleSheetFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        application.setStyleSheet(QString::fromUtf8(styleSheetFile.readAll()));
    } else {
        qCWarning(applicationLog) << "Could not load the embedded style sheet";
    }

    MainWindow mainWindow;
    mainWindow.show();

    qCInfo(applicationLog) << "Started" << QApplication::applicationName()
                           << QApplication::applicationVersion();
    return QApplication::exec();
}

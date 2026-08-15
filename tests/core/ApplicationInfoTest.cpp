#include <app/core/ApplicationInfo.hpp>

#include <QTest>
#include <QVersionNumber>

class ApplicationInfoTest final : public QObject
{
    Q_OBJECT

private slots:
    void metadataIsConfigured();
    void versionUsesSemanticShape();
};

void ApplicationInfoTest::metadataIsConfigured()
{
    QVERIFY(!app::core::ApplicationInfo::name().trimmed().isEmpty());
    QVERIFY(!app::core::ApplicationInfo::description().trimmed().isEmpty());
    QVERIFY(!app::core::ApplicationInfo::organizationName().trimmed().isEmpty());
    QVERIFY(app::core::ApplicationInfo::organizationDomain().contains(QLatin1Char('.')));
    QVERIFY(app::core::ApplicationInfo::applicationId().contains(QLatin1Char('.')));
}

void ApplicationInfoTest::versionUsesSemanticShape()
{
    const auto version = QVersionNumber::fromString(app::core::ApplicationInfo::version());
    QVERIFY(!version.isNull());
    QVERIFY(version.segmentCount() >= 3);
}

QTEST_APPLESS_MAIN(ApplicationInfoTest)

#include "ApplicationInfoTest.moc"

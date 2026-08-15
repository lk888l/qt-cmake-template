#include <app/core/ApplicationInfo.hpp>

#include <app/ProjectConfig.hpp>

#include <QString>

#include <string_view>

namespace {

[[nodiscard]] QString toQString(const std::string_view value)
{
    return QString::fromUtf8(value.data(), static_cast<qsizetype>(value.size()));
}

} // namespace

namespace app::core {

QString ApplicationInfo::name()
{
    return toQString(build::projectName);
}

QString ApplicationInfo::version()
{
    return toQString(build::projectVersion);
}

QString ApplicationInfo::description()
{
    return toQString(build::projectDescription);
}

QString ApplicationInfo::organizationName()
{
    return toQString(build::organizationName);
}

QString ApplicationInfo::organizationDomain()
{
    return toQString(build::organizationDomain);
}

QString ApplicationInfo::applicationId()
{
    return toQString(build::applicationId);
}

} // namespace app::core

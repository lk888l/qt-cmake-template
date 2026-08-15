#pragma once

#include <QString>

namespace app::core {

class ApplicationInfo final
{
public:
    ApplicationInfo() = delete;

    [[nodiscard]] static QString name();
    [[nodiscard]] static QString version();
    [[nodiscard]] static QString description();
    [[nodiscard]] static QString organizationName();
    [[nodiscard]] static QString organizationDomain();
    [[nodiscard]] static QString applicationId();
};

} // namespace app::core

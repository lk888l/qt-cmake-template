#include "MainWindow.hpp"

#include "ui_MainWindow.h"

#include <app/core/ApplicationInfo.hpp>

#include <QAction>
#include <QCloseEvent>
#include <QIcon>
#include <QMessageBox>
#include <QSettings>
#include <QStatusBar>

namespace {

constexpr auto geometryKey = "mainWindow/geometry";
constexpr auto windowStateKey = "mainWindow/state";

} // namespace

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui_(std::make_unique<Ui::MainWindow>())
{
    ui_->setupUi(this);

    setWindowTitle(app::core::ApplicationInfo::name());
    setWindowIcon(QIcon(QStringLiteral(":/qtapp/application.svg")));
    statusBar()->showMessage(tr("Ready"));

    connect(ui_->actionQuit, &QAction::triggered, this, &QWidget::close);
    connect(ui_->actionAbout, &QAction::triggered, this, &MainWindow::showAboutDialog);

    restoreWindowState();
}

MainWindow::~MainWindow() = default;

void MainWindow::closeEvent(QCloseEvent *event)
{
    saveWindowState();
    QMainWindow::closeEvent(event);
}

void MainWindow::showAboutDialog()
{
    const auto text = tr("%1\nVersion %2\n\n%3")
                          .arg(app::core::ApplicationInfo::name(),
                               app::core::ApplicationInfo::version(),
                               app::core::ApplicationInfo::description());
    QMessageBox::about(this, tr("About %1").arg(app::core::ApplicationInfo::name()), text);
}

void MainWindow::restoreWindowState()
{
    const QSettings settings;
    const auto geometry = settings.value(QLatin1StringView(geometryKey)).toByteArray();
    const auto state = settings.value(QLatin1StringView(windowStateKey)).toByteArray();

    if (!geometry.isEmpty()) {
        restoreGeometry(geometry);
    }
    if (!state.isEmpty()) {
        restoreState(state);
    }
}

void MainWindow::saveWindowState() const
{
    QSettings settings;
    settings.setValue(QLatin1StringView(geometryKey), saveGeometry());
    settings.setValue(QLatin1StringView(windowStateKey), saveState());
}

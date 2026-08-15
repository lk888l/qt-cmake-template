#pragma once

#include <QMainWindow>

#include <memory>

class QCloseEvent;

namespace Ui {
class MainWindow;
}

class MainWindow final : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow() override;

protected:
    void closeEvent(QCloseEvent *event) override;

private slots:
    void showAboutDialog();

private:
    void restoreWindowState();
    void saveWindowState() const;

    std::unique_ptr<Ui::MainWindow> ui_;
};

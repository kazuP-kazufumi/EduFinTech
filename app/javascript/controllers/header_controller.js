import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userMenu", "mobileMenu"]

  connect() {
    // ユーザーメニューボタンのクリックイベント
    const userMenuButton = document.getElementById("user-menu-button")
    const userMenu = document.getElementById("user-menu")

    if (userMenuButton && userMenu) {
      userMenuButton.addEventListener("click", () => {
        const isExpanded = userMenuButton.getAttribute("aria-expanded") === "true"
        userMenuButton.setAttribute("aria-expanded", !isExpanded)
        userMenu.classList.toggle("hidden")
      })

      // メニュー外のクリックで閉じる
      document.addEventListener("click", (event) => {
        if (!userMenuButton.contains(event.target) && !userMenu.contains(event.target)) {
          userMenuButton.setAttribute("aria-expanded", "false")
          userMenu.classList.add("hidden")
        }
      })
    }

    // モバイルメニューボタンのクリックイベント
    const mobileMenuButton = document.getElementById("mobile-menu-button")
    const mobileMenu = document.getElementById("mobile-menu")

    if (mobileMenuButton && mobileMenu) {
      mobileMenuButton.addEventListener("click", () => {
        const isExpanded = mobileMenuButton.getAttribute("aria-expanded") === "true"
        mobileMenuButton.setAttribute("aria-expanded", !isExpanded)
        mobileMenu.classList.toggle("hidden")
      })
    }
  }
} 
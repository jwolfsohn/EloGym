import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["content", "button"]
  static classes = ["hidden"]

  connect() {
    this.hiddenClass = this.hasHiddenClass ? this.hiddenClass : "hidden"
  }

  toggle() {
    this.contentTargets.forEach(target => {
      target.classList.toggle(this.hiddenClass)
    })

    if (this.hasButtonTarget) {
      const isHidden = this.contentTarget.classList.contains(this.hiddenClass)
      this.buttonTarget.setAttribute("aria-expanded", !isHidden)
    }
  }

  show() {
    this.contentTargets.forEach(target => {
      target.classList.remove(this.hiddenClass)
    })
  }

  hide() {
    this.contentTargets.forEach(target => {
      target.classList.add(this.hiddenClass)
    })
  }
}

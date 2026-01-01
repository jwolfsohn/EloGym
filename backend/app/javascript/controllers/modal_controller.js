import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["container"]

  connect() {
    // Bind escape key to close
    this.boundClose = this.close.bind(this)
    document.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
  }

  open() {
    this.containerTarget.classList.remove("hidden")
    this.containerTarget.classList.add("flex")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.containerTarget.classList.add("hidden")
    this.containerTarget.classList.remove("flex")
    document.body.style.overflow = "auto"
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  closeBackground(event) {
    if (event.target === this.containerTarget) {
      this.close()
    }
  }
}

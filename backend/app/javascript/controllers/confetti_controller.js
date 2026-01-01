import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

// Connects to data-controller="confetti"
export default class extends Controller {
  fire() {
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: ['#7c3aed', '#a78bfa', '#c4b5fd', '#ddd6fe']
    })
  }

  celebration() {
    const duration = 3 * 1000
    const animationEnd = Date.now() + duration
    const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 }

    function randomInRange(min, max) {
      return Math.random() * (max - min) + min
    }

    const interval = setInterval(function() {
      const timeLeft = animationEnd - Date.now()

      if (timeLeft <= 0) {
        return clearInterval(interval)
      }

      const particleCount = 50 * (timeLeft / duration)

      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 },
        colors: ['#7c3aed', '#a78bfa', '#c4b5fd']
      })
      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 },
        colors: ['#7c3aed', '#a78bfa', '#c4b5fd']
      })
    }, 250)
  }

  rankUp() {
    this.celebration()
  }
}

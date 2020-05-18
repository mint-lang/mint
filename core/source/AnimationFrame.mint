module AnimationFrame {
  fun request (method : Function(a)) : Number {
    `requestAnimationFrame(#{method})`
  }

  fun clear (id : Number) : Number {
    `cancelAnimationFrame(#{id}) || -1`
  }
}

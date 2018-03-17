self.window = self

importScripts('deep-diff.min.js')

const timestamp = () => {
  let date = new Date()

  let hours = date.getHours().toString().padStart(2, '0')
  let minutes = date.getMinutes().toString().padStart(2, '0')
  let seconds = date.getSeconds().toString().padStart(2, '0')

  return `${hours}:${minutes}:${seconds}`
}

const format = (item) => {
  if (typeof item == "string") {
    return `"${item}"`
  } else {
    return item
  }
}

const handleChange = (change, prefix = "") => {
  if (!change.path) { change.path = [] }

  let path = `${prefix}${change.path.join('.')}`
  switch (change.kind) {
    case 'N':
      console.log(`Added %c${path}:`, 'font-weight: bold', format(change.rhs))
      break;
    case 'D':
      console.log(`Deleted %c${path}:`, 'font-weight: bold', format(change.lhs))
      break;
    case 'E':
      console.log(`Changed %c${path}:`, 'font-weight: bold', format(change.lhs), "=>", format(change.rhs))
      break;
    case 'A':
      handleChange(change.item, `${path}[${change.index}]`)
      break;
  }
}

const diff = (message, from, to) => {
  let changes = DeepDiff.diff(from, to)

  if (changes && changes.length) {
    return {
      type: "diff",
      time: +new Date,
      timestamp: timestamp(),
      store: message,
      changes: changes
    }
  }
}

const messages = []
let processing = false

const process = () => {
  if(processing || !messages.length) { return }

  processing = true

  const event = messages.shift()

  switch (event.type) {
    case 'log':
      postMessage({
        type: "log",
        time: +new Date,
        message: `[${timestamp()}] ${event.message}`,
        params: event.params
      })
      break;

    case 'diff':
      let data = diff(event.message, event.from, event.to)
      if (data) { postMessage(data) }
      break;
  }

  processing = false

  process()
}

onmessage = function(e) {
  messages.push(e.data)
  process()
}

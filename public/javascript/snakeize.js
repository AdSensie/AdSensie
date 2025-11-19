export default function snakeize(obj) {
    if (obj && typeof obj === "object") {
        if (obj instanceof Date || obj instanceof RegExp) {
            return obj
        }

        if (Array.isArray(obj)) {
            return obj.map(snakeize)
        }

        return Object.keys(obj).reduce((acc, key) => {
            const snakeKey = key[0].toLowerCase() + key.slice(1).replace(/([A-Z]+)/g, (match, group) => {
                return "_" + group.toLowerCase()
            })
            acc[snakeKey] = snakeize(obj[key])
            return acc
        }, {})
    }

    return obj
}

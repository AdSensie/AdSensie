import "./cable_stream_source_element.js"

import * as Turbo from "@hotwired/turbo"
export { Turbo }

import * as cable from "./cable.js"
export { cable }

import { encodeMethodIntoRequestBody } from "./fetch_requests.js"

window.Turbo = Turbo

addEventListener("turbo:before-fetch-request", encodeMethodIntoRequestBody)

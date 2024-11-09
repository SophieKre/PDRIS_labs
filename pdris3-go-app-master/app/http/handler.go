package http

import "net/http"

func heathPing(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("healthy"))
}

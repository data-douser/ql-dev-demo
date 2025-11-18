package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

func OutOfMemoryBad(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	// Get user-controlled input
	sourceStr := source.Get("size")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// BAD: Uncontrolled allocation size from user input
	result := make([]string, sink)
	for i := 0; i < sink; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}

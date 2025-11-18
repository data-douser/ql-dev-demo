package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

func OutOfMemoryGood(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	MaxValue := 100
	// Get user-controlled input
	sourceStr := source.Get("size")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// GOOD: Validate the size before allocation
	if sink < 0 || sink > MaxValue {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	result := make([]string, sink)
	for i := 0; i < sink; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}

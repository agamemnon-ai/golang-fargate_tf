package main

import (
	"log"
	"net/http"
	"os"
	"text/template"
)

func root(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("root.html")
	if err != nil {
		log.Println(err)
	}
	env1 := os.Getenv("ENV1")
	text := env1 + "Golang"
	t.Execute(w, text)
}

func bye(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("root.html")
	if err != nil {
		log.Println(err)
	}
	env2 := os.Getenv("ENV2")
	text := env2 + "Golang"
	t.Execute(w, text)
}

func main() {

	http.HandleFunc("/", root)
	http.HandleFunc("/bye", bye)
	http.ListenAndServe(":8080", nil)
}

package storage

import (
	"database/sql"
	"errors"
	"fmt"
	"os"

	_ "github.com/lib/pq"
)

var (
	// DB global variable
	DB *sql.DB
	// ErrDBhostNotSet for empty DBHOST
	ErrDBhostNotSet = errors.New("DBHOST environment variable required but not set")
	// ErrDBportNotSet for empty DBPORT
	ErrDBportNotSet = errors.New("DBPORT environment variable required but not set")
	// ErrDBuserNotSet for empty DBUSER
	ErrDBuserNotSet = errors.New("DBUSER environment variable required but not set")
	// ErrDBpassNotSet for empty DBPASS
	ErrDBpassNotSet = errors.New("DBPASS environment variable required but not set")
	// ErrDBnameNotSet for empty DBNAME
	ErrDBnameNotSet = errors.New("DBNAME environment variable required but not set")
)

const (
	dbhost = "DBHOST"
	dbport = "DBPORT"
	dbuser = "DBUSER"
	dbpass = "DBPASS"
	dbname = "DBNAME"
)

func InitDb() {
	config := dbConfig()
	var err error
	psqlInfo := fmt.Sprintf("host=%s port=%s user=%s "+
		"password=%s dbname=%s sslmode=disable",
		config[dbhost], config[dbport],
		config[dbuser], config[dbpass], config[dbname])

	DB, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	err = DB.Ping()
	if err != nil {
		panic(err)
	}
	fmt.Println("Successfully connected!")
}

func dbConfig() map[string]string {
	conf := make(map[string]string)
	host, ok := os.LookupEnv(dbhost)
	if !ok {
		panic(ErrDBhostNotSet)
	}
	port, ok := os.LookupEnv(dbport)
	if !ok {
		panic(ErrDBportNotSet)
	}
	user, ok := os.LookupEnv(dbuser)
	if !ok {
		panic(ErrDBuserNotSet)
	}
	password, ok := os.LookupEnv(dbpass)
	if !ok {
		panic(ErrDBpassNotSet)
	}
	name, ok := os.LookupEnv(dbname)
	if !ok {
		panic(ErrDBnameNotSet)
	}
	conf[dbhost] = host
	conf[dbport] = port
	conf[dbuser] = user
	conf[dbpass] = password
	conf[dbname] = name
	return conf
}

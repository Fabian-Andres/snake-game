package models

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

var (
	// ErrEmptyNickname for empty Nickname
	ErrEmptyNickname = errors.New("nickname cannot be empty")
	// ErrEmptyTotalScore for empty TotalScore
	ErrEmptyTotalScore = errors.New("total score cannot be empty")
)

type Score struct {
	ScoreID      string     `json:"score_id"`
	Nickname     string     `json:"nickname"`
	TotalScore   string     `json:"total_score"`
	CreationDate *time.Time `json:"creation_date"`
}

// NewScore function to create a new score
func NewScore(nickname, totalScore string) (*Score, error) {
	switch {
	case nickname == "":
		return nil, ErrEmptyNickname
	case totalScore == "":
		return nil, ErrEmptyTotalScore
	}

	scoreID := "SCR" + uuid.New().String()
	created := time.Now()

	return &Score{
		ScoreID:      scoreID,
		Nickname:     nickname,
		TotalScore:   totalScore,
		CreationDate: &created,
	}, nil
}

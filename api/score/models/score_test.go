package models

import (
	"github.com/stretchr/testify/require"

	"testing"
)

func TestNewScore(t *testing.T) {
	c := require.New(t)

	scr, err := NewScore("anonymous", 1200)

	c.NoError(err)
	c.NotEmpty(scr.ScoreID)
	c.Regexp(
		"SCR[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}",
		scr.ScoreID)
	c.NotEmpty(scr.TotalScore)
	c.NotNil(scr.CreationDate)
}

func TestNewScoreErrors(t *testing.T) {
	c := require.New(t)

	_, err := NewScore("", 0)
	c.Equal(ErrEmptyNickname, err)
	_, err = NewScore("anonymous", 0)
	c.Equal(ErrEmptyTotalScore, err)
}

func BenchmarkNewScore(b *testing.B) {
	for n := 0; n < b.N; n++ {
		_, err := NewScore("anonymous", 1200)
		if err != nil {
			b.Fatal(err)
		}
	}
}

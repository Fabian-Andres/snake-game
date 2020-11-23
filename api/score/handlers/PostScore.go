package handlers

import (
	"encoding/json"
	"net/http"

	"bitbucket.org/truora/snake/api-app/score/models"
	"bitbucket.org/truora/snake/api-app/score/storage"
)

func PostScore(w http.ResponseWriter, r *http.Request) {
	var response models.Score

	err := json.NewDecoder(r.Body).Decode(&response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	err = execScore(response.Nickname, response.TotalScore)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)
	w.Write([]byte("score created"))

}

func execScore(nickname string, total_score int32) error {
	newScore, err := models.NewScore(nickname, total_score)
	if err != nil {
		return err
	}

	_, err = storage.DB.Exec(`
		INSERT INTO scores (
			score_id,
			nickname,
			total_score,
			creation_date
		)
		VALUES ($1, $2, $3, $4)`,
		newScore.ScoreID,
		newScore.Nickname,
		newScore.TotalScore,
		newScore.CreationDate,
	)
	if err != nil {
		return err
	}

	return nil
}

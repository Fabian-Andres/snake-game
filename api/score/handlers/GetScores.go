package handlers

import (
	"encoding/json"
	"net/http"

	"bitbucket.org/truora/snake/api-app/score/models"
	"bitbucket.org/truora/snake/api-app/score/storage"
)

type scoreList struct {
	ScoreList []models.Score `json:"score_list"`
}

func GetScores(w http.ResponseWriter, r *http.Request) {
	response := scoreList{}

	err := queryScores(&response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	resJSON, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	w.Write(resJSON)
}

func queryScores(response *scoreList) error {
	rows, err := storage.DB.Query(`
		SELECT
			score_id,
			nickname,
			total_score,
			creation_date
		FROM scores
		ORDER BY total_score DESC
		LIMIT 10`)
	if err != nil {
		return err
	}
	defer rows.Close()

	for rows.Next() {
		score := models.Score{}
		err = rows.Scan(
			&score.ScoreID,
			&score.Nickname,
			&score.TotalScore,
			&score.CreationDate,
		)
		if err != nil {
			return err
		}
		response.ScoreList = append(response.ScoreList, score)
	}
	err = rows.Err()
	if err != nil {
		return err
	}
	return nil
}

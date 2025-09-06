SELECT
  msm.music_source_id,
  msm.music_id,

  CASE msm.type
    WHEN 1 THEN 'Opening'
    WHEN 2 THEN 'Ending'
    WHEN 3 THEN 'Insert'
    WHEN 4 THEN 'BGM'
    ELSE 'Other'
  END AS music_type,

  mt.latin_title AS music_name,
  SUM(mst.stat_correct) AS stat_correct,
  SUM(mst.stat_played) AS stat_played,
  SUM(mst.stat_guessed) AS stat_guessed,
  CAST(AVG(mst.stat_averageguessms) AS int) AS stat_averageguessms,
  AVG(mv.vote) AS avg_vote,
  COUNT(mv.vote) AS music_vote_count,
  REGEXP_SUBSTR(msel.url, 'v[0-9]+') AS vndb_id,
  msel.name AS vn_name,

  EXTRACT(YEAR FROM mso.air_date_start) AS release_year,
  EXTRACT(MONTH FROM mso.air_date_start) AS release_month,

  mso.rating_bayesian,
  mso.votecount AS vn_vote_count

FROM music_source_music AS msm


LEFT JOIN music_stat AS mst
  ON msm.music_id = mst.music_id

LEFT JOIN music_source AS mso
  ON msm.music_source_id = mso.id

LEFT JOIN music_title AS mt
  ON msm.music_id = mt.music_id

LEFT JOIN music_vote AS mv
  ON msm.music_id = mv.music_id

LEFT JOIN music_source_external_link AS msel
  ON msm.music_source_id = msel.music_source_id


WHERE msel.type = 1
  AND mso.language_original LIKE 'ja'
  AND mst.stat_played > 0

GROUP BY
  msm.music_source_id,
  msm.music_id,
  music_type,
  music_name,
  vndb_id,
  vn_name,
  release_year,
  release_month,
  mso.rating_bayesian,
  vn_vote_count

ORDER BY msm.music_source_id ASC;
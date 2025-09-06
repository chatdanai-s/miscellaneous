WITH earliest_release_date AS (
  SELECT
    releases_vn.vid,
    MIN(releases.released) AS release_date
  FROM releases_vn

  INNER JOIN releases ON releases_vn.id = releases.id
  GROUP BY releases_vn.vid
),

earliest_release AS (
  SELECT DISTINCT ON (vid)
    rvn.vid,
    r.id AS rid,
    r.released AS release_date,
    COALESCE(r.minage, 0) AS age_rating

  FROM releases_vn AS rvn

  INNER JOIN releases AS r
    ON rvn.id = r.id
  INNER JOIN earliest_release_date AS erd
    ON erd.vid = rvn.vid AND erd.release_date = r.released
)

SELECT
  vn.id AS vn_id,
  er.rid AS rid,
  vn.title AS vn_title,
  er.age_rating AS age_rating,

  CASE vn.length
    WHEN 0 THEN 'Unknown'
    WHEN 1 THEN '0-2 h'
    WHEN 2 THEN '2-10 h'
    WHEN 3 THEN '10-30 h'
    WHEN 4 THEN '30-50 h'
    WHEN 5 THEN '50+ h'
    ELSE NULL
  END AS vn_length_str,

  ROUND(AVG(vn_length_votes.length)/60, 3) AS vn_length_h,

  EXISTS (
    SELECT vn_anime.id, vn_anime.id
    FROM vn_anime
    WHERE vn_anime.id = vn.id
  ) AS has_anime,
 
  EXISTS (
    SELECT tags_vn.vid, tags_vn.tag
    FROM tags_vn
    WHERE tags_vn.vid = vn.id AND tags_vn.tag = 'g214'
  ) AS is_nukige
  
FROM vn


LEFT JOIN vn_length_votes
  ON vn.id = vn_length_votes.vid

LEFT JOIN earliest_release as er
  ON vn.id = er.vid

WHERE vn.olang = 'ja'
  AND vn_length_votes.length IS NOT NULL  -- Excludes games so obscure there are no votes
  AND NOT EXISTS (
    SELECT tags_vn.vid, tags_vn.tag
    FROM tags_vn
    WHERE tags_vn.vid = vn.id AND tags_vn.tag IN ('g2711')
  )  -- Excludes Gacha games

GROUP BY
  vn_id,
  er.rid,
  vn_title,
  age_rating,
  vn_length_str,
  has_anime,
  is_nukige


ORDER BY vn_length_h DESC;
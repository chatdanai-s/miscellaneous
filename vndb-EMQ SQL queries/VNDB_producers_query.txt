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
    r.released AS release_date
  FROM releases_vn AS rvn

  INNER JOIN releases AS r
    ON rvn.id = r.id
  INNER JOIN earliest_release_date AS erd
    ON erd.vid = rvn.vid AND erd.release_date = r.released
),

producer_names AS (
  SELECT
    releases_producers.id as rid,
    producers.id AS pid,
    COALESCE(producers.latin, producers.name) AS producer
  FROM releases_producers

  LEFT JOIN producers
    ON releases_producers.pid = producers.id
)

SELECT
  er.rid AS rid,
  producer_names.producer AS producer
FROM vn


LEFT JOIN vn_length_votes
  ON vn.id = vn_length_votes.vid

LEFT JOIN earliest_release as er
  ON vn.id = er.vid

LEFT JOIN producer_names
  ON er.rid = producer_names.rid

WHERE vn.olang = 'ja'
  AND vn_length_votes.length IS NOT NULL  -- Excludes games so obscure there are no votes
  AND NOT EXISTS (
    SELECT tags_vn.vid, tags_vn.tag
    FROM tags_vn
    WHERE tags_vn.vid = vn.id AND tags_vn.tag IN ('g2711')
  )  -- Excludes Gacha games

GROUP BY
  er.rid,
  producer

ORDER BY er.rid ASC;
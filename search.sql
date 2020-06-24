WITH RECURSIVE "experts" AS (

 SELECT
   contacts.id,
   contacts.name,
   1 AS degrees_of_separation,
   ARRAY[contacts.id] AS contact_ids_path,
   ARRAY[contacts.name] AS contact_names_path

 FROM contacts
 INNER JOIN friendships ON friendships.contact_id = contacts.id
 WHERE
   friendships.friend_id = $contact_id

UNION ALL

SELECT
  contacts.id, contacts.name,
  experts.degrees_of_separation + 1,
  array_append(experts.contact_ids_path, contacts.id),
  array_append(experts.contact_names_path, contacts.name)

FROM contacts
INNER JOIN friendships ON friendships.contact_id = contacts.id
INNER JOIN experts ON friendships.friend_id = experts.id

WHERE
  (contacts.id != $contact_id)
	AND  (degrees_of_separation < 6) -- see ~kbacon

)

SELECT * FROM (

SELECT
  experts.*,

  array_agg(topics.name ORDER BY heading_level ASC) AS topic_names,
  SUM(CASE heading_level WHEN 1 THEN 10 WHEN 2 THEN 5 WHEN 3 THEN 3 ELSE 0 END) AS topic_expertise_score
  ROW_NUMBER() OVER (PARTITION BY experts.id ORDER BY degrees_of_separation ASC) as ordinality
FROM
  experts
INNER JOIN topics ON topics.contact_id = experts.id

WHERE
	topics.name ilike $query

GROUP BY 1,2,3,4,5
) t

WHERE ordinality = 1 AND degrees_of_separation > 1

ORDER BY
  e.id,
  degrees_of_separation ASC,
  topic_expertise_score DESC

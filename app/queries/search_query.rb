class SearchQuery
  ORDERS = {
    distance: { degrees_of_separation: :asc, topic_expertise_score: :desc },
    expertise: { topic_expertise_score: :desc, degrees_of_separation: :asc }
  }.with_indifferent_access.freeze

  def initialize(contact)
    @contact = contact
  end

  def call(query, sort: :distance)
    subquery = Contact.select("
      experts.*,
      array_agg(topics.name ORDER BY heading_level ASC) AS topic_names,
      SUM(#{topic_expertise_level}) AS topic_expertise_score,
      ROW_NUMBER() OVER (PARTITION BY experts.id ORDER BY degrees_of_separation ASC) = 1 AS shortest_path
    ").from('experts')
    .joins('INNER JOIN topics ON experts.id = topics.contact_id')
    .where("topics.name ilike ?", "%#{query}%")
    .group('1,2,3,4,5')

    Contact.with.recursive(experts: query_arel.to_sql)
      .select('*').from(subquery)
      .where('degrees_of_separation > 1 and shortest_path')
      .order(sort_order(sort))
  end

  private

  def query_arel
    base_case.arel.union(recursive_case.arel)
  end

  def base_case
    Contact.reselect([
      'contacts.id',
      'contacts.name',
      '1 AS degrees_of_separation',
      'ARRAY[contacts.id] AS contact_ids_path',
      'ARRAY[contacts.name] AS contact_names_path'
    ]).joins(:friendships)
    .where('friendships.friend_id = ?', @contact.id)
  end

  def recursive_case
    Contact.reselect([
      'contacts.id',
      'contacts.name',
      'experts.degrees_of_separation + 1',
      'array_append(experts.contact_ids_path, contacts.id)',
      'array_append(experts.contact_names_path, contacts.name)'
    ])
    .joins(:friendships)
    .joins('INNER JOIN experts ON friendships.friend_id = experts.id')
    .where('degrees_of_separation < 6') # see ~kbacon
    .where("contacts.id != ?", @contact.id)
  end

  def topic_expertise_level
    "CASE heading_level WHEN 1 THEN 10 WHEN 2 THEN 5 WHEN 3 THEN 3 ELSE 0 END"
  end

  def sort_order(sort)
    ORDERS.fetch(sort, ORDERS[:distance])
  end
end

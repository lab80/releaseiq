@IQ or= {}

Meteor.methods(
  createRelease: (formData) ->
    #FIXME: filter the features with formData.numCandidates and cost/benefit scores
    featureCandidates = Posts.find({}, {fields: {name: 1, cost: 1, benefit: 1}}).fetch()
    featureIds = _.map(featureCandidates, (f) -> f._id)

    planning =
      start: formData.startTime
      features: featureIds
      description: formData.desc

    build =
      start: formData.startTime
      features: []
      description: ""

    state = if build.start < new Date() then IQ.Releases.STATE.BUILDING else IQ.Releases.STATE.PLANNING

    release =
      name: formData.name
      createdAt: new Date(),
      state: state
      planning: planning,
      build: build

    return IQ.Releases.insert(
      release
    )
)

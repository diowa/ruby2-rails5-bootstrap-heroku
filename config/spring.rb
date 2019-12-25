# frozen_string_literal: true

Spring.watch(
  '.rbenv-vars',
  'tmp/restart.txt',
  'tmp/caching-dev.txt'
)

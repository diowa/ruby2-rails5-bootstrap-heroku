import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

// Prevents flicker when using Turbolinks
// Ref: https://github.com/FortAwesome/Font-Awesome/issues/11924
config.mutateApproach = 'sync'

import {
  faGithub
} from '@fortawesome/free-brands-svg-icons'

library.add(
  faGithub
)

dom.watch()

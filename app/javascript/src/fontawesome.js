import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

import {
  faGithub
} from '@fortawesome/free-brands-svg-icons'

// Prevents flicker when using Turbolinks
// Ref: https://github.com/FortAwesome/Font-Awesome/issues/11924
config.mutateApproach = 'sync'

library.add(
  faGithub
)

dom.watch()

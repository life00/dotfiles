import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Info } from '../types'

// room left for the INSERT and permission-mode labels on the footer's left
const RESERVE = 55

type EffortSettings = {
  effortLevel?: string
  modelSettings?: Record<string, { effortLevel?: string } | undefined>
}

const info = atom({ plugin: 'footer-info', key: 'info' } as const, null)

let model: string | undefined
let effort: string | number | undefined

const refresh = async ($: EngineInterface) => {
  const [cwd, sessionModel, usage, settings, git] = await Promise.all([
    $.session.cwd(),
    $.session.model(),
    $.session.usage(),
    $.settings.read(),
    $.process.run(['git', 'branch', '--show-current']).catch(() => null),
  ])
  const home = (await $.env.get('HOME')) ?? ''
  const name = model ?? sessionModel
  const { effortLevel, modelSettings } = settings as EffortSettings
  const next: Info = {
    dir: home && cwd.startsWith(home) ? '~' + cwd.slice(home.length) : cwd,
    branch: git?.exitCode === 0 ? git.stdout.trim() : '',
    model: name,
    effort: String(effort ?? modelSettings?.[name]?.effortLevel ?? effortLevel ?? ''),
    pct: usage.context.percent,
  }

  await update($, info, () => next)
}

const join = (...parts: string[]) => parts.filter(Boolean).join(' · ')

const variants = ({ dir, branch, model, effort, pct }: Info) => {
  const short = model.replace(/^claude-/, '')
  const base = dir.split('/').pop() ?? dir
  const where = (d: string) => (branch ? `${d} (${branch})` : d)
  const variant = (m: string) => [m, effort].filter(Boolean).join(':')
  const ctx = pct === undefined ? '' : `${pct}%`

  return [
    join(where(dir), variant(model), ctx && `${ctx} ctx`),
    join(where(base), variant(short), ctx),
    join(base, variant(short), ctx),
    join(variant(short), ctx),
    ctx,
  ]
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const result = await next(e)
    await refresh($)
    return result
  })

  on('turn.step', async function* ($, e, next) {
    if (e.agentId === undefined) {
      model = e.model
      effort = e.effort
    }
    yield* next(e)
  })

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    await refresh($)
    return result
  })

  on('ui.render', { component: 'SessionMode' }, async ($, e, next) => {
    const current = await read($, info)
    if (!current) return next(e)

    const room = (e.viewport?.columns ?? 200) - RESERVE - e.props.modes.join(' & ').length
    const text = variants(current).find(v => v.length <= room)

    return text ? next({ ...e, props: { modes: [...e.props.modes, text] } }) : next(e)
  })
}

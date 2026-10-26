export type Info = {
  dir: string
  branch: string
  model: string
  effort: string
  pct: number | undefined
}

declare module 'claude-code' {
  interface PluginState {
    'footer-info': { info: Info | null }
  }
}

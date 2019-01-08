action "rake" {
  uses = "./rake/"
}

workflow "New workflow" {
  on = "push"
  resolves = ["Rake"]
}

action "Rake" {
  uses = "./.github/rake"
}

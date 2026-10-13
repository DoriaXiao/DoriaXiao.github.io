// Pre-render hook (see _quarto.yml): rebuilds the PDF CV from data/*.yml
// with the Typst bundled in Quarto, so the CV can never lag the website.
const root = Deno.env.get("QUARTO_PROJECT_DIR") ?? Deno.cwd();
const binDir = Deno.env.get("QUARTO_BIN_PATH");
const quarto = binDir ? `${binDir}/quarto` : "quarto";

const out = "assets/cv/Xingyao_CV.pdf";
await Deno.mkdir(`${root}/assets/cv`, { recursive: true });
const { code } = await new Deno.Command(quarto, {
  args: ["typst", "compile", "--root", ".", "cv/cv.typ", out],
  cwd: root,
  stdout: "inherit",
  stderr: "inherit",
}).output();

if (code !== 0) {
  console.error("CV build failed; fix cv/cv.typ or data/*.yml and re-render.");
  Deno.exit(code);
}
console.log(`CV built: ${out}`);

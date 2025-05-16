import node from "./node";
import pluginReact from "eslint-plugin-react";

export default [
  { files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"] },
  ...node,
  pluginReact.configs.flat.recommended,
];

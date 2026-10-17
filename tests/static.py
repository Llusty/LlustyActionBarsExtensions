from pathlib import Path
import subprocess
root = Path(__file__).resolve().parents[1]
expected = {'Core.lua','Compatibility.lua','AssistedHighlight.lua','AdvancedFade.lua','Options.lua','Defaults.lua'}
assert {p.name for p in root.glob('*.lua')} == expected
for name in expected:
    subprocess.run(['luac','-p',str(root/name)],check=True)
    source = (root/name).read_text()
    for banned in ('hooksecurefunc(', 'OnUpdate', 'C_Timer.', 'EllesmereUIActionBarsDB', 'EABButton', 'SetAttribute(', 'RegisterStateDriver('):
        # Comments may describe deliberately rejected techniques.
        code = '\n'.join(line.split('--')[0] for line in source.splitlines())
        assert banned not in code, (name,banned)
toc=(root/'LlustyActionBarsExtensions.toc').read_text()
assert '## Dependencies: EllesmereUI, EllesmereUIActionBars' in toc
assert '## SavedVariables: LlustyActionBarsExtensionsDB' in toc
for name in expected: assert name in toc
print('PASS: six Lua syntax checks, prohibited access scan, manifest sanity')

"""
Generate a minimal TransLinka Xcode project file that references all Swift sources.

Run this on macOS after cloning:
    python3 scripts/generate_xcodeproj.py

It will recreate TransLinka.xcodeproj/project.pbxproj with a single iOS app target
named "TransLinka", linking all .swift files under the TransLinka/ directory.
"""

import os
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC_ROOT = ROOT / "TransLinka"
PROJ_FILE = ROOT / "TransLinka.xcodeproj" / "project.pbxproj"


def uid():
    return uuid.uuid4().hex[:24].upper()


def gather_swift_files():
    return sorted([str(p.relative_to(ROOT)).replace("\\", "/")
                   for p in SRC_ROOT.rglob("*.swift")])


def make_pbxproj(swift_files):
    # IDs
    project_obj = uid()
    main_group = uid()
    products_group = uid()
    target_id = uid()
    sources_phase = uid()
    frameworks_phase = uid()
    resources_phase = uid()
    product_file = uid()
    proj_build_config_list = uid()
    proj_debug = uid()
    proj_release = uid()
    target_build_config_list = uid()
    target_debug = uid()
    target_release = uid()

    file_refs = {path: uid() for path in swift_files}
    build_files = {path: uid() for path in swift_files}

    def join_lines(lines):
        return "".join(lines)

    buildfile_entries = [
        f"\t\t{build_files[path]} /* {Path(path).name} in Sources */ = "
        f"{{isa = PBXBuildFile; fileRef = {file_refs[path]} /* {Path(path).name} */; }};\n"
        for path in swift_files
    ]

    fileref_entries = [
        f"\t\t{file_refs[path]} /* {Path(path).name} */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {path}; "
        f"sourceTree = \"<group>\"; }};\n"
        for path in swift_files
    ]
    fileref_entries.append(
        f"\t\t{product_file} /* TransLinka.app */ = "
        f"{{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; "
        f"path = TransLinka.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n"
    )

    children = "".join([f"\n\t\t\t\t{fid} /* {Path(path).name} */," for path, fid in file_refs.items()])
    main_group_entry = (
        f"\t\t{main_group} = {{isa = PBXGroup; children = ({children}\n"
        f"\t\t\t\t{products_group} /* Products */\n"
        f"\t\t\t); name = TransLinka; path = .; sourceTree = \"<group>\"; }};\n"
    )
    products_group_entry = (
        f"\t\t{products_group} /* Products */ = {{isa = PBXGroup; children = (\n"
        f"\t\t\t\t{product_file} /* TransLinka.app */\n"
        f"\t\t\t); name = Products; sourceTree = \"<group>\"; }};\n"
    )

    sources_files = "".join(
        [f"\n\t\t\t\t{build_files[path]} /* {Path(path).name} in Sources */" for path in swift_files]
    )
    sources_phase_entry = (
        f"\t\t{sources_phase} /* Sources */ = {{isa = PBXSourcesBuildPhase; "
        f"buildActionMask = 2147483647; files = ({sources_files}\n\t\t\t); "
        f"runOnlyForDeploymentPostprocessing = 0; }};\n"
    )
    frameworks_phase_entry = (
        f"\t\t{frameworks_phase} /* Frameworks */ = {{isa = PBXFrameworksBuildPhase; "
        f"buildActionMask = 2147483647; files = (\n\t\t\t); "
        f"runOnlyForDeploymentPostprocessing = 0; }};\n"
    )
    resources_phase_entry = (
        f"\t\t{resources_phase} /* Resources */ = {{isa = PBXResourcesBuildPhase; "
        f"buildActionMask = 2147483647; files = (\n\t\t\t); "
        f"runOnlyForDeploymentPostprocessing = 0; }};\n"
    )

    native_target_entry = (
        f"\t\t{target_id} /* TransLinka */ = {{isa = PBXNativeTarget; "
        f"buildConfigurationList = {target_build_config_list} /* Build configuration list for PBXNativeTarget \"TransLinka\" */; "
        f"buildPhases = (\n"
        f"\t\t\t{sources_phase} /* Sources */,\n"
        f"\t\t\t{frameworks_phase} /* Frameworks */,\n"
        f"\t\t\t{resources_phase} /* Resources */,\n"
        f"\t\t); buildRules = (\n\t\t); dependencies = (\n\t\t); "
        f"name = TransLinka; productName = TransLinka; "
        f"productReference = {product_file} /* TransLinka.app */; "
        f"productType = \"com.apple.product-type.application\"; }};\n"
    )

    project_entry = (
        f"\t\t{project_obj} /* Project object */ = {{isa = PBXProject; attributes = "
        f"{{LastSwiftUpdateCheck = 1500; LastUpgradeCheck = 1500; ORGANIZATIONNAME = TransLinka; }}; "
        f"buildConfigurationList = {proj_build_config_list} /* Build configuration list for PBXProject \"TransLinka\" */; "
        f"compatibilityVersion = \"Xcode 14.0\"; developmentRegion = en; hasScannedForEncodings = 1; "
        f"knownRegions = (en, Base,); mainGroup = {main_group}; productRefGroup = {products_group} /* Products */; "
        f"projectDirPath = \"\"; projectRoot = \"\"; targets = ({target_id} /* TransLinka */); }};\n"
    )

    proj_debug_entry = f"\t\t{proj_debug} /* Debug */ = {{isa = XCBuildConfiguration; buildSettings = {{}}; name = Debug; }};\n"
    proj_release_entry = f"\t\t{proj_release} /* Release */ = {{isa = XCBuildConfiguration; buildSettings = {{}}; name = Release; }};\n"
    proj_config_list = (
        f"\t\t{proj_build_config_list} /* Build configuration list for PBXProject \"TransLinka\" */ = "
        f"{{isa = XCConfigurationList; buildConfigurations = (\n"
        f"\t\t\t{proj_debug} /* Debug */,\n"
        f"\t\t\t{proj_release} /* Release */,\n"
        f"\t\t); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};\n"
    )

    common_target_settings = (
        "ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; "
        "CODE_SIGN_STYLE = Automatic; "
        "CURRENT_PROJECT_VERSION = 1; "
        "DEVELOPMENT_TEAM = \"\"; "
        "ENABLE_PREVIEWS = YES; "
        "INFOPLIST_FILE = TransLinka/Info.plist; "
        "IPHONEOS_DEPLOYMENT_TARGET = 15.0; "
        "LD_RUNPATH_SEARCH_PATHS = (\"$(inherited)\", \"@executable_path/Frameworks\"); "
        "MARKETING_VERSION = 1.0; "
        "PRODUCT_BUNDLE_IDENTIFIER = com.translinka.app; "
        "PRODUCT_NAME = \"$(TARGET_NAME)\"; "
        "SWIFT_EMIT_LOC_STRINGS = YES; "
        "SWIFT_VERSION = 5.0; "
        "TARGETED_DEVICE_FAMILY = \"1,2\";"
    )
    target_debug_entry = (
        f"\t\t{target_debug} /* Debug */ = {{isa = XCBuildConfiguration; buildSettings = {{ {common_target_settings} }}; name = Debug; }};\n"
    )
    target_release_entry = (
        f"\t\t{target_release} /* Release */ = {{isa = XCBuildConfiguration; buildSettings = {{ {common_target_settings} }}; name = Release; }};\n"
    )
    target_config_list = (
        f"\t\t{target_build_config_list} /* Build configuration list for PBXNativeTarget \"TransLinka\" */ = "
        f"{{isa = XCConfigurationList; buildConfigurations = (\n"
        f"\t\t\t{target_debug} /* Debug */,\n"
        f"\t\t\t{target_release} /* Release */,\n"
        f"\t\t); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};\n"
    )

    out = [
        "// !$*UTF8*$!\n{\n\tarchiveVersion = 1;\n\tclasses = {};\n\tobjectVersion = 56;\n\tobjects = {\n\n",
        "/* Begin PBXBuildFile section */\n",
        *buildfile_entries,
        "/* End PBXBuildFile section */\n\n",
        "/* Begin PBXFileReference section */\n",
        *fileref_entries,
        "/* End PBXFileReference section */\n\n",
        "/* Begin PBXFrameworksBuildPhase section */\n",
        frameworks_phase_entry,
        "/* End PBXFrameworksBuildPhase section */\n\n",
        "/* Begin PBXGroup section */\n",
        main_group_entry,
        products_group_entry,
        "/* End PBXGroup section */\n\n",
        "/* Begin PBXNativeTarget section */\n",
        native_target_entry,
        "/* End PBXNativeTarget section */\n\n",
        "/* Begin PBXProject section */\n",
        project_entry,
        "/* End PBXProject section */\n\n",
        "/* Begin PBXResourcesBuildPhase section */\n",
        resources_phase_entry,
        "/* End PBXResourcesBuildPhase section */\n\n",
        "/* Begin PBXSourcesBuildPhase section */\n",
        sources_phase_entry,
        "/* End PBXSourcesBuildPhase section */\n\n",
        "/* Begin XCBuildConfiguration section */\n",
        proj_debug_entry,
        proj_release_entry,
        target_debug_entry,
        target_release_entry,
        "/* End XCBuildConfiguration section */\n\n",
        "/* Begin XCConfigurationList section */\n",
        proj_config_list,
        target_config_list,
        "/* End XCConfigurationList section */\n\n",
        "};\n\trootObject = %s /* Project object */;\n}\n" % project_obj,
    ]

    return "".join(out)


def main():
    swift_files = gather_swift_files()
    if not swift_files:
        raise SystemExit("No Swift files found under TransLinka/")
    PROJ_FILE.parent.mkdir(parents=True, exist_ok=True)
    pbx = make_pbxproj(swift_files)
    PROJ_FILE.write_text(pbx, encoding="utf-8")
    print(f"Generated project.pbxproj with {len(swift_files)} Swift files.")


if __name__ == "__main__":
    main()


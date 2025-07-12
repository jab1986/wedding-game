#!/bin/bash

# Wedding Game Development Quality Assurance Tools
# Comprehensive validation and quality checks for game development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GODOT_EXECUTABLE="godot"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORTS_DIR="${PROJECT_ROOT}/reports"

# Ensure reports directory exists
mkdir -p "$REPORTS_DIR"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to validate GDScript syntax
validate_gdscript() {
    print_status "Validating GDScript syntax..."
    
    local error_count=0
    local gdscript_files
    
    # Find all GDScript files
    mapfile -t gdscript_files < <(find "$PROJECT_ROOT" -name "*.gd" -not -path "*/addons/*" -not -path "*/reports/*")
    
    if [ ${#gdscript_files[@]} -eq 0 ]; then
        print_warning "No GDScript files found"
        return 0
    fi
    
    print_status "Found ${#gdscript_files[@]} GDScript files"
    
    # Check each file
    for file in "${gdscript_files[@]}"; do
        if ! "$GODOT_EXECUTABLE" --check-only --script "$file" &>/dev/null; then
            print_error "Syntax error in: $file"
            ((error_count++))
        fi
    done
    
    if [ $error_count -eq 0 ]; then
        print_success "All GDScript files have valid syntax"
        return 0
    else
        print_error "Found $error_count GDScript syntax errors"
        return 1
    fi
}

# Function to validate project structure
validate_project_structure() {
    print_status "Validating project structure..."
    
    local errors=0
    
    # Check for essential files
    essential_files=(
        "project.godot"
        "scenes/Main.tscn"
        "autoload/GameManager.gd"
        "autoload/AudioManager.gd"
        "autoload/SpriteManager.gd"
    )
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "$PROJECT_ROOT/$file" ]; then
            print_error "Missing essential file: $file"
            ((errors++))
        fi
    done
    
    # Check for essential directories
    essential_dirs=(
        "scenes"
        "autoload"
        "characters"
        "dialogues"
        "scripts"
    )
    
    for dir in "${essential_dirs[@]}"; do
        if [ ! -d "$PROJECT_ROOT/$dir" ]; then
            print_error "Missing essential directory: $dir"
            ((errors++))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        print_success "Project structure is valid"
        return 0
    else
        print_error "Found $errors project structure issues"
        return 1
    fi
}

# Function to validate dialogue files
validate_dialogue_files() {
    print_status "Validating dialogue files..."
    
    local dialogue_files
    mapfile -t dialogue_files < <(find "$PROJECT_ROOT/dialogues" -name "*.dialogue" 2>/dev/null)
    
    if [ ${#dialogue_files[@]} -eq 0 ]; then
        print_warning "No dialogue files found"
        return 0
    fi
    
    print_status "Found ${#dialogue_files[@]} dialogue files"
    
    local errors=0
    
    for file in "${dialogue_files[@]}"; do
        # Basic syntax validation for dialogue files
        if ! grep -q "^~ " "$file" 2>/dev/null; then
            print_warning "Dialogue file may be empty or have no titles: $file"
        fi
        
        # Check for common dialogue syntax issues
        if grep -n "^[[:space:]]*$" "$file" | head -10 >/dev/null; then
            print_status "Dialogue file has empty lines (normal): $(basename "$file")"
        fi
    done
    
    if [ $errors -eq 0 ]; then
        print_success "Dialogue files validated"
        return 0
    else
        print_error "Found $errors dialogue file issues"
        return 1
    fi
}

# Function to validate asset files
validate_assets() {
    print_status "Validating asset files..."
    
    local warnings=0
    
    # Check for sprite files
    if [ -d "$PROJECT_ROOT/sprites" ]; then
        local sprite_count
        sprite_count=$(find "$PROJECT_ROOT/sprites" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" 2>/dev/null | wc -l)
        print_status "Found $sprite_count sprite files"
    else
        print_warning "No sprites directory found"
        ((warnings++))
    fi
    
    # Check for audio files
    if [ -d "$PROJECT_ROOT/audio" ]; then
        local audio_count
        audio_count=$(find "$PROJECT_ROOT/audio" -name "*.ogg" -o -name "*.wav" -o -name "*.mp3" 2>/dev/null | wc -l)
        print_status "Found $audio_count audio files"
    else
        print_warning "No audio directory found"
        ((warnings++))
    fi
    
    # Check for large files that might cause issues
    local large_files
    mapfile -t large_files < <(find "$PROJECT_ROOT" -type f -size +10M -not -path "*/reports/*" -not -path "*/.git/*" 2>/dev/null)
    
    if [ ${#large_files[@]} -gt 0 ]; then
        print_warning "Found ${#large_files[@]} large files (>10MB):"
        for file in "${large_files[@]}"; do
            local size
            size=$(du -h "$file" | cut -f1)
            print_warning "  $size - $(basename "$file")"
        done
    fi
    
    if [ $warnings -eq 0 ]; then
        print_success "Asset validation completed"
    else
        print_warning "Asset validation completed with $warnings warnings"
    fi
    
    return 0
}

# Function to check code quality
check_code_quality() {
    print_status "Checking code quality..."
    
    local issues=0
    
    # Find GDScript files
    local gdscript_files
    mapfile -t gdscript_files < <(find "$PROJECT_ROOT" -name "*.gd" -not -path "*/addons/*" -not -path "*/reports/*")
    
    # Check for common code quality issues
    for file in "${gdscript_files[@]}"; do
        # Check for TODO comments
        local todo_count
        todo_count=$(grep -c "TODO\|FIXME\|HACK" "$file" 2>/dev/null || echo 0)
        if [ "$todo_count" -gt 0 ]; then
            print_warning "Found $todo_count TODO/FIXME/HACK comments in $(basename "$file")"
        fi
        
        # Check for long lines (>100 characters)
        local long_lines
        long_lines=$(awk 'length > 100 { print NR }' "$file" 2>/dev/null | wc -l)
        if [ "$long_lines" -gt 0 ]; then
            print_warning "Found $long_lines lines >100 characters in $(basename "$file")"
        fi
        
        # Check for missing docstrings on exported functions
        if grep -q "^func " "$file" && ! grep -q "^## " "$file"; then
            print_warning "No docstrings found in $(basename "$file")"
        fi
    done
    
    print_success "Code quality check completed"
    return 0
}

# Function to generate development report
generate_report() {
    print_status "Generating development report..."
    
    local report_file="$REPORTS_DIR/dev-qa-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "Wedding Game Development Quality Assurance Report"
        echo "================================================"
        echo "Generated: $(date)"
        echo "Project: $(basename "$PROJECT_ROOT")"
        echo ""
        
        echo "## Project Statistics"
        echo "- GDScript files: $(find "$PROJECT_ROOT" -name "*.gd" -not -path "*/addons/*" | wc -l)"
        echo "- Scene files: $(find "$PROJECT_ROOT" -name "*.tscn" | wc -l)"
        echo "- Dialogue files: $(find "$PROJECT_ROOT" -name "*.dialogue" 2>/dev/null | wc -l)"
        echo "- Total files: $(find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/reports/*" | wc -l)"
        echo ""
        
        echo "## Git Status"
        cd "$PROJECT_ROOT"
        git status --porcelain | head -20
        echo ""
        
        echo "## Recent Commits"
        git log --oneline -5
        echo ""
        
        echo "## File Sizes"
        echo "Large files (>1MB):"
        find "$PROJECT_ROOT" -type f -size +1M -not -path "*/.git/*" -not -path "*/reports/*" -exec ls -lh {} \; | head -10
        echo ""
        
    } > "$report_file"
    
    print_success "Report generated: $report_file"
}

# Function to run all checks
run_all_checks() {
    print_status "Running comprehensive quality assurance checks..."
    echo ""
    
    local total_errors=0
    
    # Run all validation functions
    validate_project_structure || ((total_errors++))
    echo ""
    
    validate_gdscript || ((total_errors++))
    echo ""
    
    validate_dialogue_files || ((total_errors++))
    echo ""
    
    validate_assets || ((total_errors++))
    echo ""
    
    check_code_quality || ((total_errors++))
    echo ""
    
    generate_report
    echo ""
    
    if [ $total_errors -eq 0 ]; then
        print_success "All quality assurance checks passed!"
        return 0
    else
        print_error "Quality assurance completed with $total_errors issues"
        return 1
    fi
}

# Main execution
main() {
    echo "🔍 Wedding Game Development QA Tools"
    echo "===================================="
    echo ""
    
    case "${1:-all}" in
        "gdscript")
            validate_gdscript
            ;;
        "structure")
            validate_project_structure
            ;;
        "dialogue")
            validate_dialogue_files
            ;;
        "assets")
            validate_assets
            ;;
        "quality")
            check_code_quality
            ;;
        "report")
            generate_report
            ;;
        "all")
            run_all_checks
            ;;
        *)
            echo "Usage: $0 [gdscript|structure|dialogue|assets|quality|report|all]"
            echo ""
            echo "Commands:"
            echo "  gdscript  - Validate GDScript syntax"
            echo "  structure - Validate project structure"
            echo "  dialogue  - Validate dialogue files"
            echo "  assets    - Validate asset files"
            echo "  quality   - Check code quality"
            echo "  report    - Generate development report"
            echo "  all       - Run all checks (default)"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
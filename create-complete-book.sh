#!/bin/bash

# 완전한 책 생성 스크립트
set -e

echo "📚 Claude Code 마스터하기 - 완전한 책 생성 시작..."

# 출력 디렉토리 생성
mkdir -p output/complete

# CSS 파일을 루트에 복사 (상대 경로 참조를 위해)
cp output/style.css ./style.css

# 통합 마크다운 파일 생성
COMPLETE_FILE="output/complete/claude-code-mastering-complete.md"

# 표지 생성
cat > "$COMPLETE_FILE" << 'EOF'
---
title: "Claude Code 마스터하기"
subtitle: "AI 페어 프로그래밍의 혁명"
author: "Claude & Human Collaboration"
date: "2024년 12월"
version: "1.0"
lang: ko
fontsize: 11pt
geometry: margin=1in
documentclass: book
toc: true
---

\newpage

# Claude Code 마스터하기
## AI 페어 프로그래밍의 혁명

**저자**: Claude & Human Collaboration  
**출판일**: 2024년 12월  
**버전**: 1.0  

---

\newpage

EOF

echo "✅ 표지 생성 완료"

# 파일 순서 배열
files=(
    "book/00-preface.md"
    "book/01-chapter1.md"
    "book/02-chapter2.md"
    "book/03-chapter3.md"
    "book/04-chapter4.md"
    "book/05-chapter5.md"
    "book/06-chapter6.md"
    "book/07-chapter7.md"
    "book/08-chapter8.md"
    "book/09-chapter9.md"
    "book/10-chapter10.md"
    "book/13-chapter13.md"
    "book/99-conclusion.md"
    "book/appendix.md"
)

# 각 파일 내용 추가
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "📄 추가 중: $file"
        echo "" >> "$COMPLETE_FILE"
        echo '\newpage' >> "$COMPLETE_FILE"
        echo "" >> "$COMPLETE_FILE"
        cat "$file" >> "$COMPLETE_FILE"
        echo "" >> "$COMPLETE_FILE"
    else
        echo "⚠️  파일을 찾을 수 없습니다: $file"
    fi
done

echo "✅ 통합 마크다운 생성 완료: $COMPLETE_FILE"

# HTML 생성
echo "🌐 HTML 생성 중..."
pandoc "$COMPLETE_FILE" \
    --from markdown \
    --to html5 \
    --css style.css \
    --standalone \
    --toc \
    --toc-depth=3 \
    --metadata title="Claude Code 마스터하기" \
    --output "output/complete/claude-code-mastering-complete.html"

# Mermaid 지원 추가
echo "🎨 Mermaid 다이어그램 지원 추가 중..."
sed -i '' 's|</body>|<!-- Mermaid 다이어그램 렌더링 -->\
<script src="https://cdn.jsdelivr.net/npm/mermaid@10.6.1/dist/mermaid.min.js"></script>\
<script>\
    mermaid.initialize({\
        startOnLoad: true,\
        theme: '\''base'\'',\
        themeVariables: {\
            primaryColor: '\''#f8fafc'\'',\
            primaryTextColor: '\''#1e293b'\'',\
            primaryBorderColor: '\''#e2e8f0'\'',\
            lineColor: '\''#94a3b8'\'',\
            secondaryColor: '\''#f1f5f9'\'',\
            tertiaryColor: '\''#e2e8f0'\''\
        },\
        flowchart: {\
            htmlLabels: false,\
            useMaxWidth: false\
        },\
        mindmap: {\
            htmlLabels: false,\
            useMaxWidth: false\
        }\
    });\
</script>\
</body>|' "output/complete/claude-code-mastering-complete.html"

echo "✅ HTML 생성 완료: output/complete/claude-code-mastering-complete.html"

# PDF 생성 (Puppeteer 사용)
echo "📄 PDF 생성 중..."
node html-to-pdf.js \
    "output/complete/claude-code-mastering-complete.html" \
    "output/complete/claude-code-mastering-complete.pdf"

echo "✅ PDF 생성 완료: output/complete/claude-code-mastering-complete.pdf"

# 파일 크기 확인
echo ""
echo "📊 생성된 파일 정보:"
ls -lh output/complete/
echo ""
echo "💾 파일 크기:"
du -h output/complete/*

echo ""
echo "🎉 완전한 책 생성 완료!"
echo "📍 위치: output/complete/"
echo "📖 PDF: output/complete/claude-code-mastering-complete.pdf"
echo "🌐 HTML: output/complete/claude-code-mastering-complete.html"
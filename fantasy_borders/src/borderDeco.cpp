#include "borderDeco.hpp"

#include <filesystem>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/desktop/Window.hpp>
#include <hyprland/src/render/Renderer.hpp>
#include <src/render/OpenGL.hpp>
#include <src/render/decorations/DecorationPositioner.hpp>

#include "BorderppPassElement.hpp"
#include "globals.hpp"

inline Hyprutils::Memory::CSharedPointer<CTexture> g_texture = nullptr;

bool g_textureLoaded = false;

std::optional<SP<CTexture>> loadAsset(const std::string& fullPath) {
    if (fullPath.empty()) {
        return std::nullopt;
    }

    const auto CAIROSURFACE = cairo_image_surface_create_from_png(fullPath.c_str());

    if (!CAIROSURFACE) {
        return std::nullopt;
    }

    const auto CAIROFORMAT = cairo_image_surface_get_format(CAIROSURFACE);
    auto       tex         = makeShared<CTexture>();

    tex->allocate();
    tex->m_size = {cairo_image_surface_get_width(CAIROSURFACE), cairo_image_surface_get_height(CAIROSURFACE)};

    const GLint glIFormat = CAIROFORMAT == CAIRO_FORMAT_RGB96F ? GL_RGB32F : GL_RGBA;
    const GLint glFormat  = CAIROFORMAT == CAIRO_FORMAT_RGB96F ? GL_RGB : GL_RGBA;
    const GLint glType    = CAIROFORMAT == CAIRO_FORMAT_RGB96F ? GL_FLOAT : GL_UNSIGNED_BYTE;

    const auto  DATA = cairo_image_surface_get_data(CAIROSURFACE);
    glBindTexture(GL_TEXTURE_2D, tex->m_texID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    if (CAIROFORMAT != CAIRO_FORMAT_RGB96F) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_SWIZZLE_R, GL_BLUE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_SWIZZLE_B, GL_RED);
    }

    glTexImage2D(GL_TEXTURE_2D, 0, glIFormat, tex->m_size.x, tex->m_size.y, 0, glFormat, glType, DATA);

    cairo_surface_destroy(CAIROSURFACE);

    return tex;
}

void onLoadTexture() {
    std::string path = "/home/flafy/Downloads/border_side3.png";
    auto a = loadAsset(path);
    if (!a.has_value()) {
        return;
    }

    g_texture = std::move(a.value());

    g_textureLoaded = true;

    Debug::log(INFO, " [fantasy_border] Texture size: %f, %f", g_texture->m_size.x, g_texture->m_size.x);
}

CBordersPlusPlus::CBordersPlusPlus(PHLWINDOW pWindow) : IHyprWindowDecoration(pWindow), m_pWindow(pWindow) {
    m_lastWindowPos  = pWindow->m_realPosition->value();
    m_lastWindowSize = pWindow->m_realSize->value();
}

CBordersPlusPlus::~CBordersPlusPlus() {
    damageEntire();
}

SDecorationPositioningInfo CBordersPlusPlus::getPositioningInfo() {
    static auto* const                        PBORDERS = (Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:add_borders")->getDataStaticPtr();

    static std::vector<Hyprlang::INT* const*> PSIZES;
    for (size_t i = 0; i < 9; ++i) {
        PSIZES.push_back((Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:border_size_" + std::to_string(i + 1))->getDataStaticPtr());
    }

    SDecorationPositioningInfo info;
    info.policy   = DECORATION_POSITION_STICKY;
    info.reserved = true;
    info.priority = 9990;
    info.edges    = DECORATION_EDGE_BOTTOM | DECORATION_EDGE_LEFT | DECORATION_EDGE_RIGHT | DECORATION_EDGE_TOP;

    if (m_fLastThickness == 0) {
        double size = 0;

        for (size_t i = 0; i < **PBORDERS; ++i) {
            size += **PSIZES[i];
        }

        info.desiredExtents = {{size, size}, {size, size}};
        m_fLastThickness    = size;
    } else
        info.desiredExtents = {{m_fLastThickness, m_fLastThickness}, {m_fLastThickness, m_fLastThickness}};

    return info;
}

void CBordersPlusPlus::onPositioningReply(const SDecorationPositioningReply& reply) {
    m_bAssignedGeometry = reply.assignedGeometry;
}

uint64_t CBordersPlusPlus::getDecorationFlags() {
    return DECORATION_PART_OF_MAIN_WINDOW;
}

eDecorationLayer CBordersPlusPlus::getDecorationLayer() {
    return DECORATION_LAYER_OVER;
}

std::string CBordersPlusPlus::getDisplayName() {
    return "Fantasy Border";
}

void CBordersPlusPlus::draw(PHLMONITOR pMonitor, const float& a) {
    if (!validMapped(m_pWindow))
        return;

    const auto PWINDOW = m_pWindow.lock();

    if (!PWINDOW->m_windowData.decorate.valueOrDefault())
        return;

    CBorderPPPassElement::SBorderPPData data;
    data.deco = this;

    g_pHyprRenderer->m_renderPass.add(makeShared<CBorderPPPassElement>(data));
}

void CBordersPlusPlus::drawPass(PHLMONITOR pMonitor, const float& a) {
    const auto PWINDOW = m_pWindow.lock();

    // static std::vector<Hyprlang::INT* const*> PCOLORS;
    // static std::vector<Hyprlang::INT* const*> PSIZES;
    // for (size_t i = 0; i < 9; ++i) {
    //     PCOLORS.push_back((Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:col.border_" + std::to_string(i + 1))->getDataStaticPtr());
    //     PSIZES.push_back((Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:border_size_" + std::to_string(i + 1))->getDataStaticPtr());
    // }
    // static auto* const PBORDERS      = (Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:add_borders")->getDataStaticPtr();
    // static auto* const PNATURALROUND = (Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "plugin:borders-plus-plus:natural_rounding")->getDataStaticPtr();
    // static auto* const PROUNDING     = (Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "decoration:rounding")->getDataStaticPtr();
    // static auto* const PBORDERSIZE   = (Hyprlang::INT* const*)HyprlandAPI::getConfigValue(PHANDLE, "general:border_size")->getDataStaticPtr();

    // if (**PBORDERS < 1)
    //     return;

    // if (m_bAssignedGeometry.width < m_seExtents.topLeft.x + 1 || m_bAssignedGeometry.height < m_seExtents.topLeft.y + 1)
    //     return;

    // const auto PWORKSPACE      = PWINDOW->m_workspace;
    // const auto WORKSPACEOFFSET = PWORKSPACE && !PWINDOW->m_pinned ? PWORKSPACE->m_renderOffset->value() : Vector2D();

    // auto       rounding      = PWINDOW->rounding() == 0 ? 0 : (PWINDOW->rounding() + **PBORDERSIZE) * pMonitor->m_scale;
    // const auto ROUNDINGPOWER = PWINDOW->roundingPower();
    // const auto ORIGINALROUND = rounding == 0 ? 0 : (PWINDOW->rounding() + **PBORDERSIZE) * pMonitor->m_scale;

    // CBox       fullBox = m_bAssignedGeometry;
    // fullBox.translate(g_pDecorationPositioner->getEdgeDefinedPoint(DECORATION_EDGE_BOTTOM | DECORATION_EDGE_LEFT | DECORATION_EDGE_RIGHT | DECORATION_EDGE_TOP, m_pWindow.lock()));

    // fullBox.translate(PWINDOW->m_floatingOffset - pMonitor->m_position + WORKSPACEOFFSET);

    // if (fullBox.width < 1 || fullBox.height < 1)
    //     return;

    // double fullThickness = 0;

    // for (size_t i = 0; i < **PBORDERS; ++i) {
    //     const int THISBORDERSIZE = **(PSIZES[i]) == -1 ? **PBORDERSIZE : (**PSIZES[i]);
    //     fullThickness += THISBORDERSIZE;
    // }

    // fullBox.expand(-fullThickness).scale(pMonitor->m_scale).round();

    // for (size_t i = 0; i < **PBORDERS; ++i) {
    //     const int PREVBORDERSIZESCALED = i == 0 ? 0 : (**PSIZES[i - 1] == -1 ? **PBORDERSIZE : **(PSIZES[i - 1])) * pMonitor->m_scale;
    //     const int THISBORDERSIZE       = **(PSIZES[i]) == -1 ? **PBORDERSIZE : (**PSIZES[i]);

    //     if (i != 0) {
    //         rounding += rounding == 0 ? 0 : PREVBORDERSIZESCALED;
    //         fullBox.x -= PREVBORDERSIZESCALED;
    //         fullBox.y -= PREVBORDERSIZESCALED;
    //         fullBox.width += PREVBORDERSIZESCALED * 2;
    //         fullBox.height += PREVBORDERSIZESCALED * 2;
    //     }

    //     if (fullBox.width < 1 || fullBox.height < 1)
    //         break;

    //     g_pHyprOpenGL->scissor(nullptr);

    if (!g_textureLoaded) {
        onLoadTexture();
    }

    static const float scale = 0.4;

    if (PWINDOW->m_realPosition->ok() && PWINDOW->m_realSize->ok() && PWINDOW->m_isFloating) {

        // Bottom Left
        const auto PWORKSPACE      = PWINDOW->m_workspace;
        const auto WORKSPACEOFFSET = PWORKSPACE && !PWINDOW->m_pinned ? PWORKSPACE->m_renderOffset->value() : Vector2D();
        auto btBox = CBox{
            WORKSPACEOFFSET.x + PWINDOW->m_realPosition->value().x - 55 * scale,
            WORKSPACEOFFSET.y + PWINDOW->m_realPosition->value().y + PWINDOW->m_realSize->value().y - g_texture->m_size.y * scale + 48 * scale,
            g_texture->m_size.x * scale,
            g_texture->m_size.y * scale,
        };

        // Top Left 
        auto tlBox = CBox{
            WORKSPACEOFFSET.x + PWINDOW->m_realPosition->value().x - 53 * scale,
            WORKSPACEOFFSET.y + PWINDOW->m_realPosition->value().y - 48 * scale,
            g_texture->m_size.x * scale,
            g_texture->m_size.y * scale,
        };
        tlBox.rot += PI/2.0;

        // Top Right
        auto trBox = CBox{
            WORKSPACEOFFSET.x + PWINDOW->m_realPosition->value().x + PWINDOW->m_realSize->value().x - g_texture->m_size.x * scale + 53 * scale,
            WORKSPACEOFFSET.y + PWINDOW->m_realPosition->value().y - 48 * scale,
            g_texture->m_size.x * scale,
            g_texture->m_size.y * scale,
        };
        trBox.rot += PI;

        // Bottom Right
        auto brBox = CBox{
            WORKSPACEOFFSET.x + PWINDOW->m_realPosition->value().x + PWINDOW->m_realSize->value().x - g_texture->m_size.x * scale + 53 * scale,
            WORKSPACEOFFSET.y + PWINDOW->m_realPosition->value().y + PWINDOW->m_realSize->value().y - g_texture->m_size.y * scale + 48 * scale,
            g_texture->m_size.x * scale,
            g_texture->m_size.y * scale,
        };
        brBox.rot -= PI/2.0;

        g_pHyprOpenGL->renderTexture(g_texture, btBox, 1.0);
        g_pHyprOpenGL->renderTexture(g_texture, tlBox, 1.0);
        g_pHyprOpenGL->renderTexture(g_texture, trBox, 1.0);
        g_pHyprOpenGL->renderTexture(g_texture, brBox, 1.0);
    }


    // m_seExtents = {{fullThickness, fullThickness}, {fullThickness, fullThickness}};

    // m_bLastRelativeBox = CBox{0, 0, m_lastWindowSize.x, m_lastWindowSize.y}.addExtents(m_seExtents);

    // if (fullThickness != m_fLastThickness) {
    //     m_fLastThickness = fullThickness;
    //     g_pDecorationPositioner->repositionDeco(this);
    // }
}

eDecorationType CBordersPlusPlus::getDecorationType() {
    return DECORATION_CUSTOM;
}

void CBordersPlusPlus::updateWindow(PHLWINDOW pWindow) {
    m_lastWindowPos  = pWindow->m_realPosition->value();
    m_lastWindowSize = pWindow->m_realSize->value();

    damageEntire();
}

void CBordersPlusPlus::damageEntire() {
    CBox dm = m_bLastRelativeBox.copy().translate(m_lastWindowPos).expand(2);
    g_pHyprRenderer->damageBox(dm);
}
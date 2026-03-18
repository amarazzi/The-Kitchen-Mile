import SwiftUI

struct MealCardView: View {
    let meal: Meal
    let mode: MealMode
    let weight: Double
    let lang: AppLanguage
    let colors: ThemeColors

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing8) {
            // Mode label
            Text(mode == .quick ? L10n.quick(lang) : L10n.cooked(lang))
                .font(.captionMedium)
                .foregroundColor(colors.secondaryText)
                .textCase(.uppercase)

            // Meal name
            Text(meal.name)
                .font(.headingSmall)
                .foregroundColor(colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            // Ingredients
            VStack(alignment: .leading, spacing: Theme.spacing4) {
                ForEach(meal.scaledIngredients(for: weight)) { ingredient in
                    HStack(spacing: Theme.spacing4) {
                        Text("·")
                            .foregroundColor(colors.secondaryText)
                        Text("\(ingredient.displayAmount()) \(ingredient.item)")
                            .font(.bodyRegular)
                            .foregroundColor(colors.secondaryText)
                    }
                }
            }

            // Prep note
            Text(meal.prepNote)
                .font(.caption)
                .foregroundColor(colors.tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, Theme.spacing4)

            Spacer(minLength: 0)

            // Kcal
            Text("~\(meal.scaledKcal(for: weight)) kcal")
                .font(.bodyMedium)
                .foregroundColor(colors.primaryText)
                .padding(.top, Theme.spacing4)
        }
        .padding(Theme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(colors.border, lineWidth: Theme.cardBorderWidth)
        )
        .overlay(
            mode == .quick ?
                HStack {
                    Rectangle()
                        .fill(Theme.easyRunColor)
                        .frame(width: Theme.quickCardBorderWidth)
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            : nil
        )
        .cornerRadius(Theme.cornerRadius)
    }
}

### Rock vs. No Rock

### Import libraries
library(lme4)
library(emmeans)
library(pbkrtest)
library(lmerTest)

### Load data set
df <- read.csv("./datasets/rockNoRockErgo.csv")

### Plot power vs. condition*subject
boxplot(power ~ condition * subject, col = c("white", "lightgray"), df)

### Fit linear mixed-effects model
df.model <- lmer(power ~ condition + (1 + condition | subject), data = df)

### Fit null-effect model without condition
df.null <- lmer(power ~ (1 + condition | subject), data = df, REML = FALSE)

### Print summary of model fit
summary(df.model)

### Perform ANOVA
anova(df.null, df.model)

### Perform paired t-tests
# df.emm.s <- emmeans(df.model, pairwise~condition)
# pairs(df.emm.s)

anova(power ~ condition, data = df, paired = TRUE)

aov()

# Jenkins Basics

## The Dashboard

When you open http://localhost:8080 and log in (admin/admin), you see the Jenkins dashboard. Key areas:

- **Left sidebar**: Navigation — New Item, People, Build History, Manage Jenkins
- **Main area**: List of jobs/pipelines
- **Build Queue**: Jobs waiting to run
- **Build Executor Status**: What's currently running and on which agent

## Jobs vs Pipelines

- **Freestyle Job**: A simple job configured through the UI. Click buttons, fill forms.
- **Pipeline**: A job defined by code (a `Jenkinsfile`). This is the modern approach and what we use in this project.

Our project has one pipeline: **address-book-pipeline**.

## Exploring a Pipeline

1. Click **address-book-pipeline** on the dashboard
2. You'll see the job page with:
   - **Build History** (left): List of past builds with status
   - **Stage View**: Visual representation of pipeline stages

## Triggering a Build

Click **Build Now** in the left sidebar. A new build appears in Build History.

## Reading Build Results

Click on a build number (e.g., `#1`) to see:

- **Console Output**: The raw log of everything that happened. This is your best debugging tool.
- **Test Result**: JUnit test report showing passed/failed tests
- **Checkstyle Warnings**: Code style issues found
- **SpotBugs Warnings**: Potential bugs found

## Build Status Icons

- Blue circle: Success
- Red circle: Failed
- Yellow circle: Unstable (tests passed but there are warnings)
- Grey circle: Not built yet / aborted

## Try It Yourself

1. Open the **address-book-pipeline** and click **Build Now**
2. Watch the **Stage View** as each stage executes
3. Click on the build number, then **Console Output** — read through the full log
4. Check the **Test Result** link to see the JUnit report
5. Look at the **Checkstyle Warnings** and **SpotBugs** links

## Next

Continue to [Pipeline Stages](04-pipeline-stages.md) to understand what each stage does.

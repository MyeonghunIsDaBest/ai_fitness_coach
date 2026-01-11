```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── sports_constants.dart
│   │   └── route_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── config/
│       └── app_config.dart
│
├── models/
│   ├── user/
│   │   ├── user_profile.dart
│   │   └── user_preferences.dart
│   ├── training/
│   │   ├── exercise.dart
│   │   ├── workout_session.dart
│   │   ├── training_program.dart
│   │   ├── set_data.dart
│   │   └── rpe_data.dart
│   ├── sports/
│   │   ├── sport_type.dart
│   │   └── sport_specific_metrics.dart
│   ├── analytics/
│   │   ├── performance_metrics.dart
│   │   ├── progress_data.dart
│   │   └── time_range.dart
│   └── form_check/
│       ├── form_analysis.dart
│       └── form_feedback.dart
│
├── providers/
│   ├── session_provider.dart
│   ├── analytics_provider.dart
│   ├── profile_provider.dart
│   ├── program_provider.dart
│   ├── navigation_provider.dart
│   ├── form_check_provider.dart
│   └── chat_provider.dart
│
├── services/
│   ├── api/
│   │   ├── api_service.dart
│   │   └── api_endpoints.dart
│   ├── storage/
│   │   ├── local_storage_service.dart
│   │   └── cache_service.dart
│   ├── ai/
│   │   ├── ai_service.dart
│   │   └── form_analysis_service.dart
│   └── auth/
│       └── auth_service.dart
│
├── screens/
│   ├── main_navigation/
│   │   ├── main_navigation_screen.dart
│   │   ├── home_tab.dart
│   │   ├── programs_tab.dart
│   │   ├── analytics_tab.dart
│   │   └── profile_tab.dart
│   │
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── quick_access_card.dart
│   │   │   ├── recent_workouts_list.dart
│   │   │   ├── stats_overview.dart
│   │   │   └── sports_selection_grid.dart
│   │   └── sport_dashboard_screen.dart
│   │
│   ├── programs/
│   │   ├── programs_overview_screen.dart
│   │   ├── program_detail_screen.dart
│   │   ├── program_selection_screen.dart
│   │   ├── create_program_screen.dart
│   │   └── templates/
│   │       ├── olympic_lifting_templates.dart
│   │       ├── powerlifting_templates.dart
│   │       ├── bodybuilding_templates.dart
│   │       └── sport_specific_templates.dart
│   │
│   ├── sports/
│   │   ├── sports_hub_screen.dart
│   │   ├── olympic_lifting/
│   │   │   ├── olympic_lifting_screen.dart
│   │   │   └── technique_library_screen.dart
│   │   ├── powerlifting/
│   │   │   └── powerlifting_screen.dart
│   │   ├── running/
│   │   │   └── running_screen.dart
│   │   ├── swimming/
│   │   │   └── swimming_screen.dart
│   │   ├── cycling/
│   │   │   └── cycling_screen.dart
│   │   └── team_sports/
│   │       ├── basketball_screen.dart
│   │       ├── football_screen.dart
│   │       └── volleyball_screen.dart
│   │
│   ├── workout/
│   │   ├── active_workout_screen.dart
│   │   ├── workout_history_screen.dart
│   │   ├── workout_summary_screen.dart
│   │   └── widgets/
│   │       ├── exercise_card.dart
│   │       ├── set_input_widget.dart
│   │       └── timer_widget.dart
│   │
│   ├── analytics/
│   │   ├── analytics_screen.dart
│   │   ├── rpe_trends_tab.dart
│   │   ├── volume_trends_tab.dart
│   │   ├── strength_progress_tab.dart
│   │   └── widgets/
│   │       ├── rpe_bar_chart.dart
│   │       ├── progress_line_chart.dart
│   │       └── stats_card.dart
│   │
│   ├── form_checker/
│   │   ├── form_checker_screen.dart
│   │   ├── camera_capture_screen.dart
│   │   ├── video_upload_screen.dart
│   │   ├── form_analysis_screen.dart
│   │   ├── form_history_screen.dart
│   │   └── widgets/
│   │       ├── video_player_widget.dart
│   │       ├── skeleton_overlay.dart
│   │       ├── angle_indicator.dart
│   │       └── feedback_card.dart
│   │
│   ├── ai_chatbot/
│   │   ├── chatbot_screen.dart
│   │   ├── widgets/
│   │   │   ├── message_bubble.dart
│   │   │   ├── quick_questions_chip.dart
│   │   │   └── typing_indicator.dart
│   │   └── chat_history_screen.dart
│   │
│   └── profile/
│       ├── profile_screen.dart
│       ├── settings_screen.dart
│       ├── edit_profile_screen.dart
│       └── preferences_screen.dart
│
├── widgets/
│   ├── common/
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   ├── empty_state.dart
│   │   └── error_widget.dart
│   ├── cards/
│   │   ├── stat_card.dart
│   │   ├── workout_card.dart
│   │   ├── program_card.dart
│   │   └── sport_card.dart
│   ├── charts/
│   │   ├── bar_chart.dart
│   │   ├── line_chart.dart
│   │   └── pie_chart.dart
│   └── dialogs/
│       ├── confirmation_dialog.dart
│       ├── input_dialog.dart
│       └── info_dialog.dart
│
├── navigation/
│   ├── app_router.dart
│   ├── route_generator.dart
│   └── navigation_helper.dart
│
└── generated/
    └── assets.dart
```

## Key Features Organization:

### 1. **Main Navigation Hub** (`screens/main_navigation/`)
- Central navigation screen with bottom navigation bar
- Quick access to all major features
- Dashboard view with personalized content

### 2. **Sports Training Programs** (`screens/sports/`)
- Individual screens for each sport type
- Sport-specific training templates
- Technique libraries and guides
- Performance tracking per sport

### 3. **Form Checker** (`screens/form_checker/`)
- Camera/video capture functionality
- AI-powered form analysis
- Visual feedback with skeleton overlay
- Historical form analysis tracking
- Exercise-specific cues and corrections

### 4. **AI Chatbot** (`screens/ai_chatbot/`)
- Conversational AI assistant
- Training advice and tips
- Form check queries
- Program recommendations
- Workout planning assistance

### 5. **Program Management** (`screens/programs/`)
- Browse available programs
- Create custom programs
- Template library (Olympic lifting, powerlifting, etc.)
- Track program progress

### 6. **Analytics Dashboard** (`screens/analytics/`)
- RPE trends tracking
- Volume and intensity analysis
- Strength progression charts
- Performance metrics visualization

## Provider Architecture:
- `navigation_provider.dart`: Manages navigation state and routing
- `form_check_provider.dart`: Handles form analysis state and data
- `chat_provider.dart`: Manages chatbot conversations and context
- Existing providers integrated seamlessly

## Future Implementation Notes:
- AI services module ready for ML model integration
- Form analysis service placeholder for computer vision
- Modular structure allows easy feature additions
- Scalable architecture for multi-sport support
```
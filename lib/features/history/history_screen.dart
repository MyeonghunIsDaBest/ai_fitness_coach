// lib/features/history/history_screen.dart

import 'package:flutter/material.dart';
import '../../domain/repositories/training_repository.dart';
import 'workout_detail_screen.dart';
import 'widgets/workout_card.dart';
import 'widgets/calendar_view.dart';

/// Main history screen showing all past workouts
class HistoryScreen extends StatefulWidget {
  final TrainingRepository repository;

  const HistoryScreen({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WorkoutSession> _sessions = [];
  bool _isLoading = true;
  String? _error;

  // Filters
  String _searchQuery = '';
  DateTime? _selectedDate;
  bool _showCompletedOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSessions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final sessions = await widget.repository.getWorkoutHistory(limit: 100);
      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<WorkoutSession> get _filteredSessions {
    var filtered = _sessions;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((session) {
        return session.workoutName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            session.sets.any((set) => set.exerciseName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Filter by selected date
    if (_selectedDate != null) {
      filtered = filtered.where((session) {
        return session.startTime.year == _selectedDate!.year &&
            session.startTime.month == _selectedDate!.month &&
            session.startTime.day == _selectedDate!.day;
      }).toList();
    }

    // Filter by completion status
    if (_showCompletedOnly) {
      filtered = filtered.where((session) => session.isCompleted).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Workout History'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFB4F04D),
          labelColor: const Color(0xFFB4F04D),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'List'),
            Tab(text: 'Calendar'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB4F04D)),
            )
          : _error != null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListView(),
                    _buildCalendarView(),
                  ],
                ),
    );
  }

  Widget _buildListView() {
    if (_filteredSessions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadSessions,
      color: const Color(0xFFB4F04D),
      child: Column(
        children: [
          _buildSearchBar(),
          _buildStats(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredSessions.length,
              itemBuilder: (context, index) {
                final session = _filteredSessions[index];
                return WorkoutCard(
                  session: session,
                  onTap: () => _navigateToDetail(session),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CalendarView(
            sessions: _sessions,
            onDaySelected: (date) {
              setState(() => _selectedDate = date);
              _tabController.animateTo(0); // Switch to list view
            },
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: 16),
            _buildSelectedDateWorkouts(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search workouts or exercises...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search, color: Colors.white60),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final totalWorkouts = _sessions.where((s) => s.isCompleted).length;
    final totalVolume = _sessions.fold<double>(
      0,
      (sum, session) => sum + session.totalVolume,
    );
    final avgRPE = _sessions.isEmpty
        ? 0.0
        : _sessions.fold<double>(0, (sum, s) => sum + s.averageRPE) /
            _sessions.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Workouts', '$totalWorkouts', Icons.fitness_center),
          _buildStatItem(
              'Volume', '${totalVolume.toStringAsFixed(0)}kg', Icons.scale),
          _buildStatItem(
              'Avg RPE', avgRPE.toStringAsFixed(1), Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFB4F04D), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDateWorkouts() {
    final dateWorkouts = _sessions.where((session) {
      return session.startTime.year == _selectedDate!.year &&
          session.startTime.month == _selectedDate!.month &&
          session.startTime.day == _selectedDate!.day;
    }).toList();

    if (dateWorkouts.isEmpty) {
      return const Text(
        'No workouts on this day',
        style: TextStyle(color: Colors.white60),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workouts on ${_formatDate(_selectedDate!)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...dateWorkouts.map((session) => WorkoutCard(
              session: session,
              onTap: () => _navigateToDetail(session),
            )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Workouts Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No workouts match your search'
                  : 'Start training to see your history',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load history',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSessions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4F04D),
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text(
                  'Completed only',
                  style: TextStyle(color: Colors.white),
                ),
                value: _showCompletedOnly,
                activeColor: const Color(0xFFB4F04D),
                onChanged: (value) {
                  setState(() => _showCompletedOnly = value);
                  Navigator.pop(context);
                },
              ),
              if (_selectedDate != null) ...[
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.clear, color: Color(0xFFB4F04D)),
                  title: const Text(
                    'Clear date filter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() => _selectedDate = null);
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(WorkoutSession session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(
          session: session,
          repository: widget.repository,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

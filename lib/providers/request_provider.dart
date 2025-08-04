import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  final RequestService _requestService = RequestService();
  
  List<RequestModel> _clientRequests = [];
  List<RequestModel> _moverRequests = [];
  List<RequestModel> _availableRequests = [];
  RequestModel? _selectedRequest;
  bool _isLoading = false;
  String? _error;

  List<RequestModel> get clientRequests => _clientRequests;
  List<RequestModel> get moverRequests => _moverRequests;
  List<RequestModel> get availableRequests => _availableRequests;
  RequestModel? get selectedRequest => _selectedRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadClientRequests(String clientId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _clientRequests = await _requestService.getClientRequests(clientId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMoverRequests(String moverId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _moverRequests = await _requestService.getMoverRequests(moverId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAvailableRequests() async {
    try {
      _setLoading(true);
      _clearError();
      
      _availableRequests = await _requestService.getAvailableRequests();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRequestById(String requestId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _selectedRequest = await _requestService.getRequestById(requestId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createRequest(RequestModel request) async {
    try {
      _setLoading(true);
      _clearError();
      
      final requestId = await _requestService.createRequest(request);
      
      if (requestId != null) {
        // Add to local client requests
        final newRequest = request.copyWith();
        _clientRequests.insert(0, newRequest);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptRequest(String requestId, String moverId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _requestService.acceptRequest(requestId, moverId);
      
      // Update local state
      _updateRequestInLists(requestId, (request) => request.copyWith(
        moverId: moverId,
        status: RequestStatus.accepted,
        updatedAt: DateTime.now(),
      ));
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateRequestStatus(String requestId, RequestStatus status) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _requestService.updateRequestStatus(requestId, status);
      
      // Update local state
      _updateRequestInLists(requestId, (request) => request.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      ));
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelRequest(String requestId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _requestService.cancelRequest(requestId);
      
      // Update local state
      _updateRequestInLists(requestId, (request) => request.copyWith(
        status: RequestStatus.cancelled,
        updatedAt: DateTime.now(),
      ));
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rateClient({
    required String requestId,
    required String clientId,
    required double rating,
    String? comment,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _requestService.rateClient(
        requestId: requestId,
        clientId: clientId,
        rating: rating,
        comment: comment,
      );
      
      // Update local state
      _updateRequestInLists(requestId, (request) => request.copyWith(
        clientRating: {
          'rating': rating,
          'comment': comment,
          'ratedAt': DateTime.now().toIso8601String(),
        },
        updatedAt: DateTime.now(),
      ));
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rateMover({
    required String requestId,
    required String moverId,
    required double rating,
    String? comment,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _requestService.rateMover(
        requestId: requestId,
        moverId: moverId,
        rating: rating,
        comment: comment,
      );
      
      // Update local state
      _updateRequestInLists(requestId, (request) => request.copyWith(
        moverRating: {
          'rating': rating,
          'comment': comment,
          'ratedAt': DateTime.now().toIso8601String(),
        },
        updatedAt: DateTime.now(),
      ));
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _updateRequestInLists(String requestId, RequestModel Function(RequestModel) updater) {
    // Update in client requests
    final clientIndex = _clientRequests.indexWhere((r) => r.id == requestId);
    if (clientIndex != -1) {
      _clientRequests[clientIndex] = updater(_clientRequests[clientIndex]);
    }
    
    // Update in mover requests
    final moverIndex = _moverRequests.indexWhere((r) => r.id == requestId);
    if (moverIndex != -1) {
      _moverRequests[moverIndex] = updater(_moverRequests[moverIndex]);
    }
    
    // Update in available requests
    final availableIndex = _availableRequests.indexWhere((r) => r.id == requestId);
    if (availableIndex != -1) {
      _availableRequests[availableIndex] = updater(_availableRequests[availableIndex]);
    }
    
    // Update selected request
    if (_selectedRequest?.id == requestId) {
      _selectedRequest = updater(_selectedRequest!);
    }
    
    notifyListeners();
  }

  List<RequestModel> getRequestsByStatus(RequestStatus status) {
    return _clientRequests.where((request) => request.status == status).toList();
  }

  List<RequestModel> getMoverRequestsByStatus(RequestStatus status) {
    return _moverRequests.where((request) => request.status == status).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void clearSelectedRequest() {
    _selectedRequest = null;
    notifyListeners();
  }
}